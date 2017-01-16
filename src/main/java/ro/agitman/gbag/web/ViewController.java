package ro.agitman.gbag.web;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.sql2o.Sql2o;


/**
 * Created by d-uu31cq on 24.11.2016.
 */
@Controller
@RequestMapping("/")
public class ViewController {

    private Gson gson = new Gson();

    @Autowired
    private Sql2o sql2o;

    // Navigation

    @RequestMapping(value = {"/"}, method = RequestMethod.GET)
    public String hompage(ModelMap model) {
        return "index";
    }

    @RequestMapping(value = {"/reports"}, method = RequestMethod.GET)
    public String reports(ModelMap model) {
        return "reports";
    }

    @RequestMapping(value = {"/help"}, method = RequestMethod.GET)
    public String help(ModelMap model) {
        return "help";
    }


    // Manage page actions

//    @RequestMapping(value = {"/savePlant"}, method = RequestMethod.POST)
//    @ResponseBody
//    public String savePlant(PlantModel plant) {
//        try (Connection con = sql2o.open()) {
//
//            if (plant.getId() != null && plant.getId() != 0) {
//                con.createQueryWithParams(UPDATE_PLANT).
//                        addParameter("name", plant.getName()).
//                        addParameter("size", plant.getSize()).
//                        addParameter("id", plant.getId()).executeUpdate();
//            } else {
//                con.createQueryWithParams(INSERT_PLANT).
//                        addParameter("name", plant.getName()).
//                        addParameter("size", plant.getSize()).executeUpdate();
//            }
//
//            List<PlantModel> tasks = con.createQuery(QUERY_PLANT).executeAndFetch(PlantModel.class);
//            return gson.toJson(tasks);
//        }
//    }

}


