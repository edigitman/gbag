package ro.agitman.gbag.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ro.agitman.gbag.service.ListService;

/**
 * Created by d-uu31cq on 23.01.2017.
 */
@Controller
@RequestMapping("/r")
public class ReportController extends AbstractController{

    @Autowired
    private ListService listService;

    @RequestMapping(value = {"lists"}, method = RequestMethod.GET, produces = "application/json; charset=utf-8")
    @ResponseBody
    public String getLists() {
        return gson.toJson(listService.selectLists(getPrincipal()));
    }

}
