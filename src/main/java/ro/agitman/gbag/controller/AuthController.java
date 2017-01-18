package ro.agitman.gbag.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Controller
@RequestMapping("/auth")
@SessionAttributes("roles")
public class AuthController {

    @RequestMapping(value = {"/isAuth"}, method = RequestMethod.GET)
    @ResponseBody
    public String reports(ModelMap model) {
        return "reports";
    }

}
