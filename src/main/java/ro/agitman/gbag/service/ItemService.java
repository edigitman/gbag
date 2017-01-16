package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.ItemModel;

import java.util.List;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Service
public class ItemService {

    private final String INSERT_ITEM = "";

    @Autowired
    private Sql2o sql2o;

    public void addItem(ItemModel item){
        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(INSERT_ITEM).
                    addParameter("name", item.getName()).
                    addParameter("qt", item.getQt()).executeUpdate();
        }
    }

    /**
     * removeItem
     * removeAllItems
     * addToBasket
     * removeFromBasket
     * archiveItem
     * archiveAllItem
     * closeList
     *
     * promoteItem
     * promoteAll
     * removeArchItem
     * clearArchived
     */


}
