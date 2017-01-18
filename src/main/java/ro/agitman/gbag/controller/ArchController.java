package ro.agitman.gbag.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
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
    private Gson gson = new Gson();

    @RequestMapping(value = {"promote"}, method = RequestMethod.POST)
    @ResponseBody
    public String promoteItem(ItemModel item) {
        itemService.promoteItem(item.getId(), getPrincipal());
        return gson.toJson(itemService.getArchItems(getPrincipal()));
    }

    @RequestMapping(value = {"promoteAll"}, method = RequestMethod.POST)
    @ResponseBody
    public String promoteAllItems() {
        itemService.promoteAllItems(getPrincipal());
        return gson.toJson(itemService.getArchItems(getPrincipal()));
    }

    @RequestMapping(value = {"clear"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String clearItem(ItemModel item) {
        itemService.clearArchItem(item.getId(), getPrincipal());
        return gson.toJson(itemService.getArchItems(getPrincipal()));
    }

    @RequestMapping(value = {"clearAll"}, method = RequestMethod.DELETE)
    @ResponseBody
    public String clearAllItems() {
        itemService.clearAllArchItems(getPrincipal());
        return gson.toJson(itemService.getArchItems(getPrincipal()));
    }

    protected String getPrincipal() {
        String userName = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            userName = ((UserDetails) principal).getUsername();
        } else {
            userName = principal.toString();
        }
        return userName;
    }
}
