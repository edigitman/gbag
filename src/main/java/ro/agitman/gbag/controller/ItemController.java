package ro.agitman.gbag.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ro.agitman.gbag.model.ItemModel;
import ro.agitman.gbag.service.ItemService;

/**
 * Created by d-uu31cq on 18.01.2017.
 */
@Controller
@RequestMapping("/i")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @RequestMapping(value = {"items"}, method = RequestMethod.GET)
    @ResponseBody
    public String getItems() {
        return "";
    }

    @RequestMapping(value = {"itemsArch"}, method = RequestMethod.GET)
    @ResponseBody
    public String getItemsArch() {
        return "";
    }


    @RequestMapping(value = {"item"}, method = RequestMethod.POST)
    @ResponseBody
    public String addItem(ItemModel item) {
        itemService.addItem(item);
        return "";
    }

    @RequestMapping(value = {"item"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeItem(ItemModel item) {
        itemService.addItem(item);
        return "";
    }

    @RequestMapping(value = {"itemAll"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeAllItems() {
        return "";
    }


    @RequestMapping(value = {"basket"}, method = RequestMethod.POST)
    @ResponseBody
    public String addItemToBasket(ItemModel item) {
        itemService.addItem(item);
        return "";
    }

    @RequestMapping(value = {"basket"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeItemFromBasket(ItemModel item) {
        itemService.addItem(item);
        return "";
    }

    @RequestMapping(value = {"arch"}, method = RequestMethod.POST)
    @ResponseBody
    public String archiveItem(ItemModel item) {
        itemService.addItem(item);
        return "";
    }

    @RequestMapping(value = {"archAll"}, method = RequestMethod.POST)
    @ResponseBody
    public String archiveAllItems() {
        return "";
    }

    @RequestMapping(value = {"closeList"}, method = RequestMethod.POST)
    @ResponseBody
    public String closeList(ItemModel item) {
        itemService.addItem(item);
        return "";
    }



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
