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

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>

<div class="container-fluid" id="app">

    <div class="row">
        <div id="accountDiv" class="col-md-8 col-md-offset-2">
            <span id="invalidCredentials" hidden>Invalid credentials - Try to register <br/></span>
            <span id="cannotRegister" hidden>Account already used <a href="#">Recover password</a> <br/></span>
            Email <input v-model="email" type="text">
            Password <input v-model="pwd" type="password">
            <button class="btn btn-default" @click="login">Login</button>
            <a href="#" @click="register">Register</a>
        </div>
        <div id="menuDiv" class="col-md-8 col-md-offset-2" style="text-align: center" hidden>
            <a class="hyperlink" href="#" @click="switchList">{{listName}}</a>  |
            <a class="hyperlink" href="reports">Reports</a> |
            <a class="hyperlink" href="logout"> Logout</a>
        </div>
    </div>

    <div class="row" hidden id="listDiv">

        <div class="col-md-8 col-md-offset-2" style="background-color: antiquewhite; margin-top: 10px">

            <div style="text-align: center; margin-top: 5px" id="addItemDiv" >
                Item <input id="itemNameId" v-model="itemName" type="text">
                qt. <input v-model="itemQt" style="width: 50px" type="number" min="0.0">
                <button class="btn btn-info" @click="addItem">Add</button>
            </div>
            <div style="text-align: center; margin-top: 5px" id="activeListItemActionsDiv">
                <div id="itemPriceDiv" hidden>
                    Price <input id="itemPrice" v-model="itemPrice" type="text">
                    <button class="btn btn-success" @click="addToBasket">A</button>
                    <button class="btn btn-danger" @click="cancelAddToBasket">C</button>
                </div>

                <div id="listPriceDiv" hidden>
                    List price<input id="listPrice" v-model="itemPrice" type="text">
                    <button class="btn btn-success" @click="closeList">A</button>
                    <button class="btn btn-danger" @click="cancelCloseList">C</button>
                </div>
           </div>

            <div style="margin-top: 5px">
                <ul id="archListUL" hidden>
                    <li v-for="(item, index) in archs">
                        <div style="width: 70%; display: inline-block">{{item.name}}</div>
                        <div style="width: 10%; display: inline-block">{{item.qt}}</div>
                        <div style="display: inline-block">
                            <button class="btn btn-info" @click="promoteItem(index)">P</button>
                            <button class="btn btn-danger" @click="removeArchItem(index)">X</button>
                        </div>
                    </li>
                </ul>

                <ul id="activeListUL">
                    <li v-for="(item, index) in items">
                        <div v-bind:class="{ bought: item.inBasket }" style="width: 70%; display: inline-block">{{item.name}}</div>
                        <div style="width: 10%; display: inline-block">{{item.qt}}</div>
                        <div v-if="!item.inBasket" style="display: inline-block">
                            <button class="btn btn-success" @click="addToBasketView(index)">B</button>
                            <button class="btn btn-info" @click="archiveItem(index)">A</button>
                            <button class="btn btn-danger" @click="removeItem(index)">X</button>
                        </div>
                        <div v-if="item.inBasket" style="display: inline-block">
                            <button class="btn btn-info" @click="removeFromBasket(index)">C</button>
                        </div>
                    </li>
                </ul>

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
        $(document).ajaxSend(function(e, xhr, options) {
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

            itemName: '',
            itemQt: '',
            itemPrice: '',
            itemSelectedIdx: ''
        },
        created: function() {
            //do a login check
            console.log("ready vue");
            $.get("auth/isAuth", function(data, status){
                console.log("data: " + data);
                console.log("status: " + status);
                if("notAuth" != data){
                    $("#accountDiv").hide();
                    $("#menuDiv").show();
                    $("#listDiv").show();
                    $("#itemNameId").focus();
                    //todo load items
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
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });

                self.items.push({name: self.itemName, qt: self.itemQt});
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
                $.ajax({ type: "DELETE", url: "i/item", data: {id: index}, success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });
                self.items = filter;
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
                $.ajax({ type: "DELETE", url: "i/itemAll", success: function(data, status){
                    console.log("data: " + data);
                    console.log("status: " + status);
                }
                });
                self.items = filter;
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
                var cItem;
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
                self.items = filter;

                self.cancelAddToBasket();

                $.ajax({
                    type: "POST",
                    url: "i/basket",
                    data: {id: self.itemSelectedIdx, price: self.itemPrice},
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });
            },
            removeFromBasket: function(index){
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
                var cIndex = cItem.index;

                delete cItem.inBasket;
                delete cItem.index;

                filter.splice(cIndex, 0, cItem);

                self.items = filter;

                $.ajax({ type: "DELETE", url: "i/basket", data: {id: index}, success: function(data, status){
                    console.log("data: " + data);
                    console.log("status: " + status);
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
                self.items = filter;
                $.ajax({
                    type: "POST",
                    url: "i/arch",
                    data: {id: index},
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
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

                self.items = filter;
                $.ajax({
                    type: "POST",
                    url: "i/archAll",
                    data: {},
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });
            },
            closeListView: function () {
                // consider the current list completed
                // archive un-bought ones, save list as closed for statistics
                $("#addItemDiv").hide();
                $("#listPriceDiv").show();
            },
            cancelCloseList: function(){
                $("#listPriceDiv").hide();
                $("#addItemDiv").show();
            },
            closeList: function(){
                //todo save list and final list price

                this.cancelCloseList();
            },


            switchList: function () {
                // switch between active and archived list
                var self = this;
                if(self.listName === 'active'){
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

                }else{
                    // switch to active
                    self.listName = 'active';

                    $("#addItemDiv").show();
                    $("#activeListCtrl").show();
                    $("#activeListUL").show();
                    $("#activeListItemActionsDiv").show();

                    $("#archListUL").hide();
                    $("#archListCtrl").hide();
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
                self.archs = filter;
                $.ajax({
                    type: "POST",
                    url: "a/promote",
                    data: {id: index},
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
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
                self.archs = [];
                $.ajax({
                    type: "POST",
                    url: "a/promoteAll",
                    data: {},
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });
            },
            removeArchItem: function(index){
                var self = this;
                var filter = [];
                for (var i = 0; i < self.archs.length; i++) {
                    if (i != index) {
                        filter.push(self.archs[i]);
                    }
                }
                self.archs = filter;
                $.ajax({type: "DELETE", url: "a/clear", data: {id: index}, success: function (data, status) {
                        console.log("data: " + data);
                        console.log("status: " + status);
                    }
                });
            },
            clearArchived: function () {
                // remove all archived
                this.archs = [];
                $.ajax({type: "DELETE", url: "a/clearAll", success: function (data, status) {
                    console.log("data: " + data);
                    console.log("status: " + status);
                }
                });
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
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);

                        if("notAuth" != data){
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
                    success: function(data, status){
                        console.log("data: " + data);
                        console.log("status: " + status);

                        if("ok" == data){
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