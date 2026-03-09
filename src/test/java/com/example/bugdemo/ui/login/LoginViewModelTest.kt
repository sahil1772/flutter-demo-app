package com.example.bugdemo.ui.login

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.lifecycle.Observer
import com.example.bugdemo.data.local.AppDatabase
import com.example.bugdemo.data.local.UserDao
import com.example.bugdemo.data.model.User
import com.example.bugdemo.data.remote.ApiClient
import com.example.bugdemo.ui.login.LoginViewModel // Added: Explicitly import the ViewModel under test
import com.example.bugdemo.ui.login.LoginResult    // Added: Explicitly import the LoginResult data class/sealed class
import io.mockk.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.*
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

/**
 * Unit tests for the LoginViewModel.
 *
 * This class uses JUnit 4, MockK for mocking, and kotlinx.coroutines.test for coroutines.
 * It verifies the behavior of the LoginViewModel and its interaction with LoginRepository,
 * ensuring the bug fix (persisting user data after successful login) is correctly implemented.
 */
@ExperimentalCoroutinesApi
class LoginViewModelTest {

    // Rule to make LiveData work instantly on a background thread for testing
    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    // Rule for coroutine testing, providing a TestDispatcher
    private val testDispatcher = UnconfinedTestDispatcher()
    private val testScope = TestScope(testDispatcher)

    // Mocks for external dependencies of LoginRepository and AppDatabase
    private lateinit var mockApiClient: ApiClient
    private lateinit var mockUserDao: UserDao
    private lateinit var mockAppDatabase: AppDatabase

    // The ViewModel under test
    private lateinit var loginViewModel: LoginViewModel

    // Observer for loginResult LiveData to capture emitted values
    private lateinit var loginResultObserver: Observer<LoginResult>

    @Before
    fun setup() {
        // Set the Main dispatcher to our test dispatcher for coroutines
        Dispatchers.setMain(testDispatcher)

        // Initialize MockK annotations for this test class and relax Unit returning functions
        MockKAnnotations.init(this, relaxUnitFun = true)

        // Mock static method call for AppDatabase.getInstance()
        mockkStatic(AppDatabase::class)
        // Create mocks for the database and its DAO
        mockAppDatabase = mockk()
        mockUserDao = mockk()
        // Define behavior for the static getInstance() and subsequent userDao() calls
        every { AppDatabase.getInstance() } returns mockAppDatabase
        every { mockAppDatabase.userDao() } returns mockUserDao

        // Mock the constructor of ApiClient because LoginRepository instantiates it internally
        mockkConstructor(ApiClient::class)
        // Capture the constructed instance for mocking its methods
        mockApiClient = anyConstructed()

        // Initialize the ViewModel. The ViewModel's internal LoginRepository will be
        // created using the mocked AppDatabase.getInstance().userDao() and the mocked ApiClient.
        loginViewModel = LoginViewModel()

        // Create a relaxed observer for the loginResult LiveData to capture changes
        loginResultObserver = mockk(relaxed = true)
        loginViewModel.loginResult.observeForever(loginResultObserver)
    }

    @After
    fun teardown() {
        // Reset the Main dispatcher to its original state
        Dispatchers.resetMain()
        // Remove the observer to prevent memory leaks and interference with other tests
        loginViewModel.loginResult.removeObserver(loginResultObserver)
        // Clear all MockK mocks, including static and constructor mocks
        clearAllMocks()
    }

    @Test
    fun `successful login persists user and updates loginResult with user email (FIXED behavior)`() = testScope.runTest {
        // GIVEN
        val testUser = User(id = "user123", email = "test@example.com", password = "password123")
        val username = "test@example.com"
        val password = "password123"

        // Define behavior for ApiClient.login to return a successful user
        coEvery { mockApiClient.login(username, password) } returns testUser
        // Define behavior for UserDao.updateUser (it's a suspend function, we just need it to run)
        coJustRun { mockUserDao.updateUser(any()) }

        // WHEN
        loginViewModel.login(username, password)
        // Advance the dispatcher to ensure all coroutines launched by ViewModelScope.launch complete
        advanceUntilIdle()

        // THEN
        // Verify that UserDao.updateUser was called exactly once with the correct User object
        verify(exactly = 1) { mockUserDao.updateUser(testUser) }

        // Verify that loginResult LiveData emitted a successful LoginResult with the user
        val capturedLoginResult = slot<LoginResult>()
        verify(exactly = 1) { loginResultObserver.onChanged(capture(capturedLoginResult)) }
        val result = capturedLoginResult.captured

        assertTrue(result.success, "Login should be successful")
        assertNotNull(result.user, "User object should not be null in LoginResult")
        assertEquals(testUser.email, result.user?.email, "The user email in result should match the authenticated user")
        assertEquals(testUser, result.user, "The user object in result should be the authenticated user")
        assertEquals(null, result.error, "Error message should be null for successful login")
    }

    @Test
    fun `login with invalid credentials does not persist user and updates loginResult with error (EDGE CASE)`() = testScope.runTest {
        // GIVEN
        val username = "wrong@example.com"
        val password = "wrongpass"

        // Define behavior for ApiClient.login to return null for invalid credentials
        coEvery { mockApiClient.login(username, password) } returns null
        // Ensure UserDao.updateUser would not be called (though we verify this explicitly later)
        coJustRun { mockUserDao.updateUser(any()) }

        // WHEN
        loginViewModel.login(username, password)
        advanceUntilIdle()

        // THEN
        // Verify that UserDao.updateUser was never called
        verify(exactly = 0) { mockUserDao.updateUser(any()) }

        // Verify that loginResult LiveData emitted an unsuccessful LoginResult with an error message
        val capturedLoginResult = slot<LoginResult>()
        verify(exactly = 1) { loginResultObserver.onChanged(capture(capturedLoginResult)) }
        val result = capturedLoginResult.captured

        assertFalse(result.success, "Login should be unsuccessful for invalid credentials")
        assertEquals("Invalid credentials", result.error, "Error message should indicate invalid credentials")
        assertEquals(null, result.user, "User object should be null for unsuccessful login")
    }

    @Test
    fun `successful login with different user still works and persists correctly (NORMAL PATH)`() = testScope.runTest {
        // GIVEN
        val anotherUser = User(id = "user456", email = "another@domain.com", password = "securepassword")
        val username = "another@domain.com"
        val password = "securepassword"

        // Define behavior for ApiClient.login for a different successful user
        coEvery { mockApiClient.login(username, password) } returns anotherUser
        coJustRun { mockUserDao.updateUser(any()) }

        // WHEN
        loginViewModel.login(username, password)
        advanceUntilIdle()

        // THEN
        // Verify that UserDao.updateUser was called exactly once with the correct User object
        verify(exactly = 1) { mockUserDao.updateUser(anotherUser) }

        // Verify that loginResult LiveData emitted a successful LoginResult with the correct user
        val capturedLoginResult = slot<LoginResult>()
        verify(exactly = 1) { loginResultObserver.onChanged(capture(capturedLoginResult)) }
        val result = capturedLoginResult.captured

        assertTrue(result.success, "Login should be successful for this user")
        assertNotNull(result.user, "User object should not be null")
        assertEquals(anotherUser.email, result.user?.email, "The user email should match the authenticated user")
        assertEquals(anotherUser.id, result.user?.id, "The user ID should match the authenticated user")
        assertEquals(anotherUser, result.user, "The user object should be the authenticated user")
        assertEquals(null, result.error, "Error message should be null for successful login")
    }
}