<%--
  Created by IntelliJ IDEA.
  User: d-uu31cq
  Date: 16.01.2017
  Time: 10:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>gbag - reports</title>

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
        <div id="menuDiv" class="col-md-8 col-md-offset-2" style="text-align: center">
            <a class="hyperlink" href="<%=request.getContextPath()%>/">Lists view</a>
        </div>
    </div>

    <div class="row" style="margin-top: 10px">
        <div class="col-md-8 col-md-offset-2 col-xs-12">
            <table width="100%">
                <thead>
                <tr>
                    <th width="50%">Shop</th>
                    <th width="25%">Price</th>
                    <th width="25%">Date</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(list, index) in lists">
                    <td>{{list.shop}}</td>
                    <td>{{list.price}}</td>
                    <td>{{list.createDate}}</td>
                </tr>
                </tbody>
            </table>
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
            lists: []
        },
        created: function () {
            //do a login check
            var self = this;
            console.log("ready vue");

            $.ajax({
                type: "GET",
                url: "r/lists",
                contentType: 'application/json; charset=utf-8',
                success: function (data, status) {
                    console.log("data: " + data);
                    console.log("status: " + status);
                    self.lists = data;
                }
            });
        },
        methods: {}
    });

</script>

</body>
</html>
