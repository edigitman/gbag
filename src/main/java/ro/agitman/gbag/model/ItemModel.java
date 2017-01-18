package ro.agitman.gbag.model;

import java.math.BigDecimal;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
public class ItemModel {

    private Long id;
    private String name;
    private BigDecimal qt;
    private Boolean inBasket;
    private BigDecimal price;
    private Long listId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getQt() {
        return qt;
    }

    public void setQt(BigDecimal qt) {
        this.qt = qt;
    }

    public Boolean getInBasket() {
        return inBasket;
    }

    public void setInBasket(Boolean inBasket) {
        this.inBasket = inBasket;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Long getListId() {
        return listId;
    }

    public void setListId(Long listId) {
        this.listId = listId;
    }
}
