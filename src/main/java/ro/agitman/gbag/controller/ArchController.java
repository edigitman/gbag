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
@RequestMapping("/a")
public class ArchController {

    @Autowired
    private ItemService itemService;


    @RequestMapping(value = {"promote"}, method = RequestMethod.POST)
    @ResponseBody
    public String promoteItem(ItemModel item) {
        return "";
    }

    @RequestMapping(value = {"promoteAll"}, method = RequestMethod.POST)
    @ResponseBody
    public String promoteAllItems() {
        return "";
    }

    @RequestMapping(value = {"clear"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String clearItem(ItemModel item) {
        return "";
    }

    @RequestMapping(value = {"clearAll"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String clearAllItems() {
        return "";
    }
}
