package ro.agitman.gbag.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ro.agitman.gbag.model.ItemModel;
import ro.agitman.gbag.model.MyUser;
import ro.agitman.gbag.service.ItemService;
import ro.agitman.gbag.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;


/**
 * Created by d-uu31cq on 24.11.2016.
 */
@Controller
@RequestMapping("/")
public class ViewController {

    @Autowired
    private UserService userService;

    // Navigation

    @RequestMapping(value = {"/"}, method = RequestMethod.GET)
    public String hompage() {
        return "index";
    }

    @RequestMapping(value = {"/login"}, method = RequestMethod.GET)
    @ResponseBody
    public String loginPage() {
        return "notAuth";
    }

    @RequestMapping(value = {"/login"}, method = RequestMethod.POST)
    @ResponseBody
    public String loginPost(MyUser myUser) {
        return "notAuthReg";
    }

    @RequestMapping(value = {"/Access_Denied"}, method = RequestMethod.GET)
    @ResponseBody
    public String accessDenied(MyUser myUser) {
        return "accessDenied";
    }

    @RequestMapping(value = {"/register"}, method = RequestMethod.POST)
    @ResponseBody
    public String registerPost(MyUser myUser) {

        if (userService.isValidUser(myUser)) {
            userService.insertUser(myUser);

            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("user"));

            Authentication auth = new UsernamePasswordAuthenticationToken(myUser.getEmail(), myUser.getPassword(), authorities);

            SecurityContextHolder.getContext().setAuthentication(auth);

            return "ok";
        }

        return "ko";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/?logout";//You can redirect wherever you want, but generally it's a good practice to show login screen again.
    }

    @RequestMapping(value = {"/reports"}, method = RequestMethod.GET)
    public String reports() {
        return "reports";
    }
}


