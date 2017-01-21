package ro.agitman.gbag.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
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
public class ItemController extends AbstractController{

    @Autowired
    private ItemService itemService;

    @RequestMapping(value = {"items"}, method = RequestMethod.GET)
    @ResponseBody
    public String getItems() {
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"itemsArch"}, method = RequestMethod.GET)
    @ResponseBody
    public String getItemsArch() {
        return gson.toJson(itemService.getArchItems(getPrincipal()));
    }


    @RequestMapping(value = {"item"}, method = RequestMethod.POST)
    @ResponseBody
    public String addItem(ItemModel item) {
        itemService.addItem(item, getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"item"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeItem(@RequestBody ItemModel item) {
        itemService.removeItem(item.getId(), getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"itemAll"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeAllItems() {
        itemService.removeAllItems(getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }


    @RequestMapping(value = {"basket"}, method = RequestMethod.POST)
    @ResponseBody
    public String addItemToBasket(@RequestBody ItemModel item) {
        itemService.addItemToBasket(item, getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"basket"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String removeItemFromBasket(@RequestBody ItemModel item) {
        itemService.removeItemFromBasket(item, getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"arch"}, method = RequestMethod.POST)
    @ResponseBody
    public String archiveItem(ItemModel item) {
        itemService.archiveItem(item.getId(), getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"archAll"}, method = RequestMethod.POST)
    @ResponseBody
    public String archiveAllItems() {
        itemService.archiveAllItems(getPrincipal());
        return gson.toJson(itemService.getItems(getPrincipal()));
    }

    @RequestMapping(value = {"closeList"}, method = RequestMethod.POST)
    @ResponseBody
    public String closeList(ItemModel item) {
        //TODO ---
//        itemService.addItem(item);
        return "";
    }
}
