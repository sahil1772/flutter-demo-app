import com.example.bugdemo.data.local.UserDao // Import for UserDao
import com.example.bugdemo.data.model.User
import com.example.bugdemo.data.remote.ApiClient

class LoginRepository(private val userDao: UserDao) { // Inject UserDao via constructor
    private val apiClient = ApiClient()