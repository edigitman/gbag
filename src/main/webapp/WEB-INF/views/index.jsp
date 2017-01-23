<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>gbag - list</title>

    <script src="static/js/jquery-2.2.4.min.js"></script>
    <script src="static/js/vuejs-2.1.6.js"></script>

    <link rel="stylesheet" type="text/css" href="static/css/style.css">

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

<div class="container-fluid" id="app">

    <div class="row">
        <div id="accountDiv" class="col-md-4 col-md-offset-4">
            <span id="invalidCredentials" hidden>Invalid credentials - Try to register <br/></span>
            <span id="cannotRegister" hidden>Account already used <a href="#">Recover password</a> <br/></span>
            <div class="form-group">
                <label for="exampleInputEmail1">Email address</label>
                <input type="email" v-model="email" @keyup.13="passFocusTo('passwordInput')" class="form-control" id="exampleInputEmail1" placeholder="Email">
            </div>
            <div class="form-group">
                <label for="passwordInput">Password</label>
                <input id="passwordInput" type="password" v-model="pwd" @keyup.13="passFocusTo('passwordInput')" class="form-control" placeholder="Password">
            </div>
            <button class="btn btn-default" @click="login">Login</button>
            <a href="#" @click="register">Register</a>
        </div>
        <div id="menuDiv" class="col-md-8 col-md-offset-2" style="text-align: center" hidden>
            <a class="hyperlink" href="#" @click="switchList">{{listName}}</a> |
            <%--<a class="hyperlink" href="reports">Reports</a> |--%>
            <a class="hyperlink" href="logout"> Logout</a>
        </div>
    </div>

    <div class="row" hidden id="listDiv">

        <div class="col-md-8 col-md-offset-2" style="background-color: antiquewhite; margin-top: 10px">

            <div class="row" style="text-align: center; margin-top: 5px" id="addItemDiv">
                <div class="col-md-8 col-xs-8">
                    <input id="itemNameId" v-model="itemName" @keyup.13="passFocusTo('itemQuantity')" style="width: 100%" type="text" placeholder="Item">
                </div>
                <div class="col-md-2 col-xs-2">
                    <input id="itemQuantity" v-model="itemQt" @keyup.13="passFocusTo('addItemBtn')" style="width: 100%" type="number" min="0.0" placeholder="qt.">
                </div>
                <div class="col-md-2 col-xs-2">
                    <button id="addItemBtn" class="btn btn-info" @click="addItem">Add</button>
                </div>
            </div>
            <div style="text-align: center; margin-top: 5px" id="activeListItemActionsDiv">
                <div id="itemPriceDiv" hidden>
                    Price <input id="itemPrice" v-model="itemPrice" @keyup.13="passFocusTo('addToBasketBtn')" type="number">
                    <button id="addToBasketBtn" class="btn btn-success" @click="addToBasket">B</button>
                    <button class="btn btn-danger" @click="cancelAddToBasket">C</button>
                </div>

                <div id="listPriceDiv" hidden class="row">
                    <div class="col-md-12">
                        List price<input id="listPrice" v-model="listPrice" @keyup.13="passFocusTo('shopNameInput')" type="number">
                    </div>
                    <div class="col-md-12">
                        Shop <input id="shopNameInput" v-model="shopName" @keyup.13="passFocusTo('closeListBtn')" type="text">
                    </div>
                    <button id="closeListBtn" class="btn btn-success" @click="closeList">A</button>
                    <button class="btn btn-danger" @click="cancelCloseList">C</button>
                </div>
            </div>

            <div style="margin-top: 5px">
                <div id="archListUL" hidden>
                    <div v-for="(item, index) in archs" class="row">
                        <div class="col-xs-6" style="display: inline-block">{{item.name}}</div>
                        <div class="col-sx-2" style="display: inline-block">{{item.qt}}</div>
                        <div class="col-xs-4" style="display: inline-block">
                            <button class="btn btn-info" @click="promoteItem(item.id)">P</button>
                            <button class="btn btn-danger" @click="removeArchItem(item.id)">X</button>
                        </div>
                    </div>
                </div>

                <div id="activeListUL">

                    <div id="listOfItems" style="margin-top: 5px">
                        <div class="row" v-for="(item, index) in items">
                            <div v-bind:class="{ bought: item.inBasket }" class="col-xs-6"
                                 style="display: inline-block">
                                {{item.name}}
                            </div>
                            <div class="col-xs-1" style="display: inline-block">{{item.qt}}</div>
                            <div v-if="!item.inBasket" class="col-xs-5" style="display: inline-block">
                                <button class="btn btn-success" @click="addToBasketView(item.id)">B</button>
                                <button class="btn btn-info" @click="archiveItem(item.id)">A</button>
                                <button class="btn btn-danger" @click="removeItem(item.id)">X</button>
                            </div>
                            <div v-if="item.inBasket" class="col-xs-5" style="display: inline-block">
                                <button class="btn btn-info" @click="removeFromBasket(item.id)">C</button>
                                <div style="display: inline-block">{{item.price}}</div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div style="text-align: right" class="col-md-2 col-md-offset-9">
                            total: {{totalListPrice}}
                        </div>
                    </div>
                </div>

                <div style="text-align: center" id="activeListCtrl">
                    <button class="btn btn-success" v-if="items.length > 0" @click="closeListView()">Close List</button>
                    <button class="btn btn-info" v-if="items.length > 0" @click="archiveAllItem()">Arch All</button>
                    <button class="btn btn-danger" v-if="items.length > 0" @click="removeAllItems()">Rem All</button>
                </div>

                <div style="text-align: center" id="archListCtrl" hidden>
                    <button class="btn btn-info" v-if="archs.length > 0" @click="promoteAll()">Promote All</button>
                    <button class="btn btn-danger" v-if="archs.length > 0" @click="clearArchived()">Rem All</button>
                </div>

            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    <%--https://docs.spring.io/spring-security/site/docs/current/reference/html/csrf.html--%>
    $(function () {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader(header, token);
        });
    });

    var app = new Vue({
        el: '#app',
        data: {
            items: [],
            archs: [],
            email: '',
            pwd: '',
            listName: 'active',
            listPrice: '',
            shopName: '',

            itemName: '',
            itemQt: '',
            itemPrice: '',
            itemSelectedIdx: ''
        },
        computed: {
            // a computed getter
            totalListPrice: function () {
                var self = this;
                // `this` points to the vm instance
                var total = 0;
                $.each(self.items, function (index, value) {
                    if (value.price) {
                        total = total + value.price;
                    }
                });
                return total;
            }
        },
        created: function () {
            //do a login check
            var self = this;
            console.log("ready vue");
            $.get("auth/isAuth", function (data, status) {
                console.log("data: " + data);
                console.log("status: " + status);
                if ("notAuth" != data) {
                    $("#accountDiv").hide();
                    $("#menuDiv").show();
                    $("#listDiv").show();
                    $("#itemNameId").focus();
                    self.items = data;
                }
            });
        },
        methods: {
            // active list actions
            addItem: function () {
                // get the current item name and size an add it to the list
                var self = this;
                console.log(self.itemName + " - " + self.itemQt);

                $.ajax({
                    type: "POST",
                    url: "i/item",
                    data: {name: self.itemName, qt: self.itemQt},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });

//                self.items.push({name: self.itemName, qt: self.itemQt});
                self.itemName = '';
                self.itemQt = '';
                $("#itemNameId").focus();
            },
            removeItem: function (index) {
                // remove item from list
                var self = this;
                var filter = [];
                for (var i = 0; i < self.items.length; i++) {
                    if (i != index) {
                        filter.push(self.items[i]);
                    }
                }

                $.ajax({
                    type: "DELETE",
                    url: "i/item",
                    data: JSON.stringify({id: index}),
                    contentType: 'application/json; charset=utf-8',
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
//                self.items = filter;
            },
            removeAllItems: function () {
                // remove all items that are not already bought
                var self = this;
                var filter = [];
                for (var i = 0; i < self.items.length; i++) {
                    if (self.items[i].inBasket) {
                        filter.push(self.items[i]);
                    }
                }
                $.ajax({
                    type: "DELETE", url: "i/itemAll", success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
//                self.items = filter;
            },
            addToBasketView: function (index) {
                // try to gather as much info about the item
                // price total, qt , price / qt, brand / model
                var self = this;
                self.itemSelectedIdx = index;
                $("#addItemDiv").hide();
                $("#itemPriceDiv").show();
                $("#itemPrice").focus();
            },
            cancelAddToBasket: function () {
                // hide and clear add to basket form
                var self = this;
                self.itemPrice = '';
                self.itemSelectedIdx = '';
                $("#itemPriceDiv").hide();
                $("#addItemDiv").show();
            },
            addToBasket: function () {
                // mark item as saved
                var self = this;

                var filter = [];
                var cItem = {};
                for (var i = 0; i < self.items.length; i++) {
                    if (i != self.itemSelectedIdx) {
                        filter.push(self.items[i]);
                    } else {
                        cItem = self.items[i];
                    }
                }
                cItem.price = self.itemPrice;
                cItem.inBasket = true;
                cItem.index = self.itemSelectedIdx;
                filter.push(cItem);
//                self.items = filter;

                self.cancelAddToBasket();

                $.ajax({
                    type: "POST",
                    url: "i/basket",
                    data: JSON.stringify({id: cItem.index, price: cItem.price}),
                    contentType: 'application/json; charset=utf-8',
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
            },
            removeFromBasket: function (index) {
                var self = this;
                var filter = [];
                var cItem;
                for (var i = 0; i < self.items.length; i++) {
                    if (i != index) {
                        filter.push(self.items[i]);
                    } else {
                        cItem = self.items[i];
                    }
                }
                // put the item in the old index in list
//                var cIndex = cItem.index;
//
//                delete cItem.inBasket;
//                delete cItem.index;
//
//                filter.splice(cIndex, 0, cItem);

//                self.items = filter;

                $.ajax({
                    type: "DELETE",
                    url: "i/basket",
                    data: JSON.stringify({id: index}),
                    contentType: 'application/json; charset=utf-8',
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
            },
            archiveItem: function (index) {
                // archive item - to a secondary list
                var self = this;
                var filter = [];
                for (var i = 0; i < self.items.length; i++) {
                    if (i != index) {
                        filter.push(self.items[i]);
                    } else {
                        self.archs.push(self.items[i]);
                        console.log('archived: ' + self.items[i].name + " - " + self.items[i].qt);
                    }
                }
//                self.items = filter;
                $.ajax({
                    type: "POST",
                    url: "i/arch",
                    data: {id: index},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
            },
            archiveAllItem: function () {
                // archive all item - to a secondary list
                var self = this;
                var filter = [];
                for (var i = 0; i < self.items.length; i++) {
                    if (self.items[i].inBasket) {
                        filter.push(self.items[i]);
                    } else {
                        self.archs.push(self.items[i]);
                    }
                }

//                self.items = filter;
                $.ajax({
                    type: "POST",
                    url: "i/archAll",
                    data: {},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });
            },
            closeListView: function () {
                // consider the current list completed
                // archive un-bought ones, save list as closed for statistics
                $("#addItemDiv").hide();
                $("#listPriceDiv").show();
            },
            cancelCloseList: function () {
                $("#listPriceDiv").hide();
                $("#addItemDiv").show();
            },
            closeList: function () {
                //todo save list and final list price
                var self = this;
                $.ajax({
                    type: "POST",
                    url: "i/closeList",
                    data: {price: self.listPrice, shop: self.shopName},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.items = data;
                    }
                });

                this.cancelCloseList();
            },


            switchList: function () {
                // switch between active and archived list
                var self = this;
                if (self.listName === 'active') {
                    // switch to archived
                    self.listName = 'arch';

                    $("#addItemDiv").hide();
                    $("#itemPriceDiv").hide();
                    $("#listPriceDiv").hide();
                    $("#activeListCtrl").hide();
                    $("#activeListUL").hide();
                    $("#activeListItemActionsDiv").hide();

                    $("#archListUL").show();
                    $("#archListCtrl").show();

                    $.ajax({
                        type: "GET",
                        url: "i/itemsArch",
                        contentType: 'application/json; charset=utf-8',
                        success: function (data, status) {
                            console.log("data: " + data);
                            console.log("status: " + status);
                            self.archs = data;
                        }
                    });

                } else {
                    // switch to active
                    self.listName = 'active';

                    $("#addItemDiv").show();
                    $("#activeListCtrl").show();
                    $("#activeListUL").show();
                    $("#activeListItemActionsDiv").show();

                    $("#archListUL").hide();
                    $("#archListCtrl").hide();

                    $.ajax({
                        type: "GET",
                        url: "i/items",
                        contentType: 'application/json; charset=utf-8',
                        success: function (data, status) {
                            console.log("data: " + data);
                            console.log("status: " + status);
                            self.items = data;
                        }
                    });
                }
            },


            // archived list actions

            promoteItem: function (index) {
                // move item to active list
                var self = this;
                var filter = [];
                for (var i = 0; i < self.archs.length; i++) {
                    if (i == index) {
                        self.items.push(self.archs[i]);
                    } else {
                        filter.push(self.archs[i]);
                    }
                }
//                self.archs = filter;
                $.ajax({
                    type: "POST",
                    url: "a/promote",
                    data: {id: index},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.archs = data;
                    }
                });
            },
            promoteAll: function () {
                // promote all items to active list
                // also switch to active list
                var self = this;
                for (var i = 0; i < self.archs.length; i++) {
                    self.items.push(self.archs[i]);
                }
//                self.archs = [];
                $.ajax({
                    type: "POST",
                    url: "a/promoteAll",
                    data: {},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.archs = data;
                    }
                });
            },
            removeArchItem: function (index) {
                var self = this;
                var filter = [];
                for (var i = 0; i < self.archs.length; i++) {
                    if (i != index) {
                        filter.push(self.archs[i]);
                    }
                }
//                self.archs = filter;
                $.ajax({
                    type: "DELETE",
                    url: "a/clear",
                    data: JSON.stringify({id: index}),
                    contentType: 'application/json; charset=utf-8',
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.archs = data;
                    }
                });
            },
            clearArchived: function () {
                // remove all archived
//                this.archs = [];
                var self = this;
                $.ajax({
                    type: "DELETE", url: "a/clearAll", success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                        self.archs = data;
                    }
                });
            },

            passFocusTo: function(element){
                $('#'+element).focus();
            },

            // account actions

            login: function () {
                var self = this;
                var errorMsg = $("#invalidCredentials");
                console.log(self.email + " -- " + self.pwd);


                errorMsg.hide();
                $.ajax({
                    type: "POST",
                    url: "login",
                    data: {email: self.email, password: self.pwd},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);

                        if ("notAuth" != data) {
                            location.reload();
                        } else {
                            // user or pass incorect
                            errorMsg.show();
                        }
                    }
                });


                // do a post to login - get a token to put as cookie
                // get the list of active items
                // hide top form - show some menu: logout / reports / archived
                // show list div
            },
            register: function () {
                var self = this;
                console.log(self.email + " -- " + self.pwd);
                var errorMsg = $("#cannotRegister");

                errorMsg.hide();
                $("#invalidCredentials").hide();
                $.ajax({
                    type: "POST",
                    url: "register",
                    data: {email: self.email, password: self.pwd},
                    success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);

                        if ("ok" == data) {
                            $("#accountDiv").hide();
                            $("#menuDiv").show();
                            $("#listDiv").show();
                            $("#itemNameId").focus();
                        } else {
                            // user or pass incorect
                            errorMsg.show();
                        }
                    }
                });
            }
        }
    });

</script>

</body>
</html>