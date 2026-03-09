import com.example.bugdemo.data.local.AppDatabase // Import for AppDatabase
import kotlinx.coroutines.launch

data class LoginResult(val success: Boolean, val user: User? = null, val error: String? = null)

class LoginViewModel : ViewModel() {
    private val repository: LoginRepository = LoginRepository(AppDatabase.getInstance().userDao()) // Inject UserDao
    private val _loginResult = MutableLiveData<LoginResult>()