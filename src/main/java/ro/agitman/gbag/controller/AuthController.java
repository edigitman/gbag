package ro.agitman.gbag.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import ro.agitman.gbag.service.ItemService;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Controller
@RequestMapping("/auth")
@SessionAttributes("roles")
public class AuthController extends AbstractController{

    @Autowired
    private ItemService itemService;

    @RequestMapping(value = {"/isAuth"}, method = RequestMethod.GET,
            produces = "application/json; charset=utf-8")
    @ResponseBody
    public String reports(ModelMap model) {
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

}
