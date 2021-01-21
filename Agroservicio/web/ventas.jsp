<%-- 
    Document   : ventas
    Created on : May 10, 2019, 2:29:07 PM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*"%>
<%@page import="Entidades.DBAdmin"%> 
<%@page import="Entidades.Venta"%>
<%@page import="Entidades.ProductoPorVenta"%>

<%
    DBAdmin dba = (DBAdmin) pageContext.getAttribute("dba", pageContext.SESSION_SCOPE);
    String campo = "", filtro = "", info = "", id_venta= ""; String indexRad = "";  
%>

<%  
    try
    {
        //Realizar consulta.
        if (request.getParameter("btnBuscar") != null) {

            filtro = request.getParameter("txtFiltro");  

            if (request.getParameter("rad").equals("ID Venta")) {
                campo = "id_venta"; info = "Búsqueda por 'Identificación de venta': '"+filtro.toUpperCase()+"'";
                id_venta = filtro; indexRad="ID Venta";
            }

            else if (request.getParameter("rad").equals("Fecha")) {
                campo = "fecha"; info = "Búsqueda por 'Fecha de venta': '"+filtro.toUpperCase()+"'"; indexRad="Fecha";
            }
        }
        
        //ostrando Venta y productos por venta.
        if (request.getParameter("btnVerDetalles") != null) {
            campo = "id_venta";  id_venta = request.getParameter("txtId_Detalles"); filtro = id_venta; 
            info = "Mostrando detalles de venta identificada: '"+ id_venta +"'";
        }  
    }
    catch(Exception ex) {}
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Agroservicio - Ventas</title>
        <link type="text/css" href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="css/theme.css" rel="stylesheet">
        <link type="text/css" href="images/icons/css/font-awesome.css" rel="stylesheet">
        <link type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">
    </head>

    <body>
        <!--–– Panel superior ––-->
        <div class="navbar navbar-fixed-top">
            <div class="container">
                <a class="brand" href="inventario.jsp"> Agroservicio / Panel de administración / Ventas </a>
            </div>
        </div>

        <div class="wrapper"  style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
            <div class="container">
                <div class="row">

                    <!--–– Barra de navegación - lateral ––-->
                    <div class="span3" style = "height: 500px;">
                        <div class="sidebar">

                            <!--–– Inventario ––-->
                            <ul class="widget widget-menu unstyled">
                                <li></li>
                                <li> <a href="inventario.jsp"> <i class="menu-icon icon-inbox"></i> Inventario </a> </li>
                                <li> </li> <li> </li> <li> </li>
                            </ul>

                            <!--–– Ventas / Registrar venta / Compras / Registrar compra ––-->
                            <ul class="widget widget-menu unstyled">
                                <li></li>
                                <li><a href="ventas.jsp"><i class="menu-icon icon-table"></i>Ventas</a> </li>                         
                                <li><a href="registrar_venta.jsp"><i class="menu-icon icon-paste"></i>Registrar venta</a> </li>                              
                                <li><a href="compras.jsp"><i class="menu-icon icon-table"></i>Compras</a> </li>                            
                                <li><a href="registrar_compra.jsp"><i class="menu-icon icon-paste"></i>Registrar compra</a> </li>                             
                                </li> <li> </li> <li> </li> <li> </li>
                            </ul>

                            <!--–– Salir ––-->
                            <ul class="widget widget-menu unstyled">
                                <li></li>
                                <li><a href="index.jsp"><i class="menu-icon icon-signout"></i>Salir</a> </li>                              
                                </li> <li> </li> <li> </li> <li> </li>
                            </ul>
                        </div>
                    </div>

                    <!--–– 1. Panel principal ––-->
                    <div class="span9">
                        <div class="content">
                            <div class="module">

                                <!--–– 1.1 Búsqueda ––-->
                                <div class="module-head" style="height: 79px;">
                                    <h3 style="margin-left: 3px; margin-top: 9px; width: 138px; pointer-events: auto;">Búsqueda por:</h3>

                                    <!--–– Formulario Búsqueda ––-->
                                    <form class="form-vertical" action = "ventas.jsp" method = "POST" name = "Formulario_búsqueda">
                                        
                                        <!--–– btnBuscar ––-->
                                        <button class="btn" type="submit" name="btnBuscar" style="width: 38px; height: 32px; margin-left: 205px; margin-top: 6px;">
                                            <i class="icon-search"></i>
                                        </button>

                                        <!--–– txtFiltro ––-->
                                        <input type="text" name ="txtFiltro" placeholder="Ingresar ID/Fecha..." class="span3" style="left: 415px; top: -27px; height: 25px; margin-left: -246px; width: 195px; margin-top: 15px;">

                                        <!--–– btnReiniciarB ––-->
                                        <input class="btn btn-success btn-md" name="btnReiniciarB" type="submit" value = "Reiniciar búsqueda" style = "height: 30px; width: 150px; margin-left: 40px; margin-top: 6px;">

                                        <!--–– txtID_detalles ––-->
                                        <input type="text" name ="txtId_Detalles" placeholder="Ingresar ID..." class="span3" style="left: 415px; top: -27px; height: 25px; margin-left: 100px; width: 120px; margin-top: 15px;">

                                        <!--–– btnVerDetalles ––-->
                                        <input class="btn btn-primary btn-md" name="btnVerDetalles" type="submit" value = "Ver detalles de venta" style="height: 32px; width: 180px; margin-left: 10px; margin-top: 6px;">

                                       <!--–– Filtros de búsqueda ––-->
                                        <div class="controls" style="margin-left: 113px; margin-top: -84px;">

                                            <!--–– Búsqueda por ID Venta ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad" id="ID Venta"  value="ID Venta" checked=""> ID Venta
                                            </label>

                                            <!--–– Búsqueda por Fecha de venta ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad" id="Fecha" value="Fecha"> Fecha (YYYY-MM-dd)
                                            </label>
                                        </div>
                                    </form>
                                </div>

                                <!--–– 1.2 Tabla Ventas ––-->
                                <div class="module-body" style="margin-top: 4px;"
                                     style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID Venta</th>
                                                <th>Fecha de venta</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    ArrayList<Venta> lVentas = dba.listarVentas(campo, filtro);
                                                    for (int i = 0; i < lVentas.size(); i++) {                                                       
                                            %>
                                            <tr>
                                                <td><%= lVentas.get(i).getId_venta()%></td>
                                                <td><%= lVentas.get(i).getString_fecha()%></td>
                                            </tr>
                                            <%
                                                    }
                                                } catch(Exception ex) {}
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!--–– 2. Panel - Productos por Venta ––-->
                            <div class="module">
                                <div class="module-head" style="height: 24px;">
                                    <h3 style="pointer-events: auto; margin-top: 4px; margin-left: 4px; width: 300px;">> Detalles de venta: (Productos por venta) </h3>
                                </div>

                                <!--–– 2.1 Tabla Productos por Venta ––-->
                                <div class="module-body" style="margin-top: 4px;"
                                     style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID Venta</th>
                                                <th>ID Producto</th>
                                                <th>Nombre de producto</th>
                                                <th>Cantidad</th>
                                                <th>Precio Unitario</th>
                                                <th>Precio de venta</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    ArrayList<ProductoPorVenta> lProductosPorVenta = dba.listarProductos_venta(id_venta);
                                                    for (int i = 0; i < lProductosPorVenta.size(); i++) {                                                       
                                            %>
                                            <tr>
                                                <td><%= lProductosPorVenta.get(i).getId_venta()%></td>
                                                <td><%= lProductosPorVenta.get(i).getId_producto()%></td>
                                                <td><%= lProductosPorVenta.get(i).getNombre()%></td>
                                                <td><%= lProductosPorVenta.get(i).getCantidad()%></td>
                                                <td><%= lProductosPorVenta.get(i).getPrecio()%> $</td>
                                                <td><%= lProductosPorVenta.get(i).getPrecioVenta()%> $</td>
                                            </tr> 
                                            <%
                                                    }
                                                } catch(Exception ex) {}
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--–– Footer - Información ––-->
        <div class="container"> 
            <br>
            <div class="alert alert-success">
                > Usuario activo: <%= dba.getUsuario()%> <br>
                > <%= info%>
            </div>
        </div>
    </body>
</html>

<script>  
    try { document.getElementById("<%= indexRad %>").checked = true;} catch(ex) {}
</script>