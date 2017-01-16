package ro.agitman.gbag.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.stereotype.Service;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import ro.agitman.gbag.model.PersistentLogin;

import java.util.Date;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
@Service("tokenRepositoryDao")
public class MyPersistentTokenRepository implements PersistentTokenRepository {

    private String CREATE_TOKEN = "";
    private String SELECT_TOKEN = "";
    private String DELETE_TOKEN = "";
    private String UPDATE_TOKEN = "";

    @Autowired
    private Sql2o sql2o;

    @Override
    public void createNewToken(PersistentRememberMeToken token) {
//        logger.info("Creating Token for user : {}", token.getUsername());
        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(CREATE_TOKEN).
                    addParameter("username", token.getUsername()).
                    addParameter("series", token.getSeries()).
                    addParameter("token", token.getTokenValue()).
                    addParameter("date_updated", token.getDate()).executeUpdate();
        }
    }

    @Override
    public PersistentRememberMeToken getTokenForSeries(String seriesId) {
//        logger.info("Fetch Token if any for seriesId : {}", seriesId);
        try (Connection con = sql2o.open()) {
            PersistentLogin login = con.createQueryWithParams(SELECT_TOKEN).addParameter("series", seriesId).executeAndFetchFirst(PersistentLogin.class);
            return new PersistentRememberMeToken(login.getUsername(), login.getSeries(), login.getToken(), login.getLast_used());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void removeUserTokens(String username) {
//        logger.info("Removing Token if any for user : {}", username);
        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(DELETE_TOKEN).addParameter("username", username).executeUpdate();
        }
    }

    @Override
    public void updateToken(String seriesId, String tokenValue, Date lastUsed) {
//        logger.info("Updating Token for seriesId : {}", seriesId);
        try (Connection con = sql2o.open()) {
            con.createQueryWithParams(UPDATE_TOKEN).
                    addParameter("token", tokenValue).
                    addParameter("date_updated", lastUsed).
                    addParameter("series", seriesId).executeUpdate();
        }
    }
}
