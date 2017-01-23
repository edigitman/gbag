package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.ClosedListModel;
import ro.agitman.gbag.model.MyUser;

import java.util.List;

/**
 * Created by d-uu31cq on 23.01.2017.
 */
@Service
public class ListService {

    private final String LIST_QUERY = "select * from closedlist where owner = :owner";

    @Autowired
    private Sql2o sql2o;
    @Autowired
    private UserService userService;

    public List<ClosedListModel> selectLists(String email) {
        MyUser user = userService.getByEmail(email);

        try (Connection con = sql2o.open()) {
            return con.createQueryWithParams(LIST_QUERY).
                    addParameter("owner", user.getId()).executeAndFetch(ClosedListModel.class);
        }
    }
}
