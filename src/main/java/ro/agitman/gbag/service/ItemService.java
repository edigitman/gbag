package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.ClosedListModel;
import ro.agitman.gbag.model.ItemModel;
import ro.agitman.gbag.model.MyUser;

import java.util.List;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Service
public class ItemService {

    private final String GET_ITEMS = "select * from items where owner = :owner and arch = false and bought = false order by inbasket";
    private final String GET_ARCH_ITEMS = "select * from items where owner = :owner and arch = true and bought = false";
    private final String INSERT_ITEM = "insert into items (owner, name, qt, bought) values (:owner, :name, :qt, :bought)";
    private final String DELETE_ITEM = "delete from items where id = :id and owner = :owner and inbasket = false";
    private final String DELETE_ALL_ITEMS = "delete from items where owner = :owner and inbasket = false and bought = false";
    private final String BASKET_ADD_ITEM = "update items set inbasket = true, price = :price where id = :id and owner = :owner";
    private final String BASKET_REMOVE_ITEM = "update items set inbasket = false, price = 0 where id = :id and owner = :owner";
    private final String ARCHIVE_ITEM = "update items set arch = :arch where id = :id and owner = :owner and inbasket = false";
    private final String ARCHIVE_ALL_ITEMS = "update items set arch = :arch where owner = :owner and inbasket = false and bought = false";
    private final String CLEAR_ARCH_ITEM = "delete from items where arch = true and owner = :owner and id = :id";
    private final String CLEAR_ALL_ARCH_ITEMS = "delete from items where arch = true and owner = :owner and bought = false";
    private final String INSERT_CLOSED_LIST = "insert into closedlist (shop, price, owner) values(:shop, :price, :owner)";
    private final String UPDATE_CLOSED_LIST_ITEMS = "update items set listid = :listid, bought = true where owner = :owner and bought = false";

    @Autowired
    private Sql2o sql2o;
    @Autowired
    private UserService userService;

    public void addItem(ItemModel item, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(INSERT_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("name", item.getName()).
                    addParameter("bought", false).
                    addParameter("qt", item.getQt()).executeUpdate();
        }
    }

    public void removeItem(Long id, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(DELETE_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("id", id).executeUpdate();
        }
    }

    public void removeAllItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(DELETE_ALL_ITEMS).
                    addParameter("owner", user.getId()).executeUpdate();
        }
    }

    public void addItemToBasket(ItemModel item, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(BASKET_ADD_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("id", item.getId()).
                    addParameter("price", item.getPrice()).executeUpdate();
        }
    }

    public void removeItemFromBasket(ItemModel item, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(BASKET_REMOVE_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("id", item.getId()).executeUpdate();
        }
    }

    public void archiveItem(Long id, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(ARCHIVE_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("arch", true).
                    addParameter("id", id).executeUpdate();
        }
    }

    public void archiveAllItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(ARCHIVE_ALL_ITEMS).
                    addParameter("owner", user.getId()).
                    addParameter("arch", true).executeUpdate();
        }
    }

    public void promoteItem(Long id, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(ARCHIVE_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("arch", false).
                    addParameter("id", id).executeUpdate();
        }
    }

    public void promoteAllItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(ARCHIVE_ALL_ITEMS).
                    addParameter("owner", user.getId()).
                    addParameter("arch", false).executeUpdate();
        }
    }

    public void clearArchItem(Long id, String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(CLEAR_ARCH_ITEM).
                    addParameter("owner", user.getId()).
                    addParameter("id", id).executeUpdate();
        }
    }

    public void clearAllArchItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(CLEAR_ALL_ARCH_ITEMS).
                    addParameter("owner", user.getId()).executeUpdate();
        }
    }

    public List<ItemModel> getItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            return con.createQueryWithParams(GET_ITEMS).
                    addParameter("owner", user.getId()).executeAndFetch(ItemModel.class);
        }
    }

    public List<ItemModel> getArchItems(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            return con.createQueryWithParams(GET_ARCH_ITEMS).
                    addParameter("owner", user.getId()).executeAndFetch(ItemModel.class);
        }
    }

    public void closeList(ClosedListModel closedList, String principal) {
        MyUser user = userService.getByEmail(principal);


        try (Connection con = sql2o.beginTransaction()) {
            Integer id = (Integer) con.createQuery(INSERT_CLOSED_LIST, true).
                    addParameter("shop", closedList.getShop()).
                    addParameter("price", closedList.getPrice()).
                    addParameter("owner", user.getId()).executeUpdate().getKey();


            con.createQuery(UPDATE_CLOSED_LIST_ITEMS).
                    addParameter("listid", id).
                    addParameter("owner", user.getId()).executeUpdate();

            con.commit();
        }
    }
}
