package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.MyUser;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Service("userDetailsService")
public class MyUserDetailsService implements UserDetailsService {

    public static final String SELECT_USER = "select * from users where email = :email";

    @Autowired
    private Sql2o sql2o;

    @Transactional(readOnly = true)
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        try (Connection con = sql2o.open()) {
            MyUser user = con.createQueryWithParams(SELECT_USER).addParameter("email", username).executeAndFetchFirst(MyUser.class);

            if (user == null) {
                throw new UsernameNotFoundException("User " + username + " not found.");
            }

            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority(user.getRole()));

            return new User(user.getEmail(), user.getPassword(),
                    user.isEnabled(), true, true, true, authorities);
        }
    }
}
