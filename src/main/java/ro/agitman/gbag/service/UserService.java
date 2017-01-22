package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.MyUser;

/**
 * Created by d-uu31cq on 18.01.2017.
 */
@Service
public class UserService {

    private static String INSERT_USER = "insert into users (email, password, enabled, role) values (:email, :password, :enabled, :role)";

    @Autowired
    private Sql2o sql2o;
    @Autowired
    private PasswordEncoder encoder;

    public MyUser getByEmail(String email) {
        try (Connection con = sql2o.open()) {
            return con.createQueryWithParams(MyUserDetailsService.SELECT_USER)
                    .addParameter("email", email.toLowerCase()).executeAndFetchFirst(MyUser.class);
        }
    }

    public boolean isValidUser(MyUser user) {

        if (user == null)
            return false;
        if (user.getEmail() == null || user.getEmail().trim().isEmpty())
            return false;
        if (user.getPassword() == null || user.getPassword().trim().isEmpty())
            return false;
        //todo check email format and password strength min 8 chars

        try (Connection con = sql2o.open()) {
            MyUser dbUser = con.createQueryWithParams(MyUserDetailsService.SELECT_USER)
                    .addParameter("email", user.getEmail().toLowerCase()).executeAndFetchFirst(MyUser.class);

            return dbUser == null;
        }
    }

    public void insertUser(MyUser user) {
        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(INSERT_USER)
                    .addParameter("email", user.getEmail().toLowerCase())
                    .addParameter("password", encoder.encode(user.getPassword()))
                    .addParameter("enabled", true)
                    .addParameter("role", "user").executeUpdate();
        }
    }
}
