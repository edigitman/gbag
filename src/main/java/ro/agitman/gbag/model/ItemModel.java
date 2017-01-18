package ro.agitman.gbag.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by d-uu31cq on 16.01.2017.
 */
public class ItemModel {

    private Long id;
    private Long owner;
    private String name;
    private BigDecimal qt;
    private Boolean inBasket;
    private BigDecimal price;
    private Boolean arch;
    private Long listId;
    private Date createDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOwner() {
        return owner;
    }

    public void setOwner(Long owner) {
        this.owner = owner;
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

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Boolean getArch() {
        return arch;
    }

    public void setArch(Boolean arch) {
        this.arch = arch;
    }
}
