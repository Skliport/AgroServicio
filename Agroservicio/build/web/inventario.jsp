<%-- 
    Document   : inventario
    Created on : May 10, 2019, 2:28:49 PM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*"%>
<%@page import="Entidades.DBAdmin"%> 
<%@page import="Entidades.Producto"%> 

<%
    DBAdmin dba = (DBAdmin) pageContext.getAttribute("dba", pageContext.SESSION_SCOPE);
    String campo = "", filtro = "", info = ""; String indexRad = ""; 
%>

<%  
    try
    {
        //Consultando.
        if (request.getParameter("btnBuscar") != null) {

            filtro = request.getParameter("txtFiltro");  

            //Consulta por ID Producto.
            if (request.getParameter("rad").equals("ID Producto")) {
                campo = "id_producto"; info = "Búsqueda por 'Identificación de producto': '"+filtro.toUpperCase()+"'";
                indexRad = "ID Producto";
            }

            //Consulta por nombre de producto.
            else  if (request.getParameter("rad").equals("Nombre")) {
                campo = "nombre"; info = "Búsqueda por 'Nombre de producto': '"+filtro.toUpperCase()+"'";
                indexRad = "Nombre";
            }

            //Consulta por fabricante.
            else  if (request.getParameter("rad").equals("Fabricante")) {
                campo = "fabricante"; info = "Búsqueda por 'Fabricante de producto': '"+filtro.toUpperCase()+"'";
                indexRad = "Fabricante";
            }

            //Consulta por categoría.
            else  if (request.getParameter("rad").equals("Categoria")) {
                campo = "categoria"; info = "Búsqueda por 'Categoría de producto': '"+filtro.toUpperCase()+"'";
                indexRad = "Categoria";
            }
        }
    }
    catch(Exception ex) {}
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Agroservicio - Inventario</title>
        <link type="text/css" href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="css/theme.css" rel="stylesheet">
        <link type="text/css" href="images/icons/css/font-awesome.css" rel="stylesheet">
        <link type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">
    </head>

    <body>
        <!--–– Panel superior ––-->
        <div class="navbar navbar-fixed-top">
            <div class="container">
                <a class="brand" href="inventario.jsp"> Agroservicio / Panel de administración / Inventario </a>
            </div>
        </div>

        <div class="wrapper" style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
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
                                    <form class="form-vertical" action = "inventario.jsp" method = "POST" name = "Formulario_búsqueda">
                                         
                                        <!--–– btnBuscar ––-->
                                        <button class="btn" type="submit" name="btnBuscar" style="width: 38px; height: 32px; margin-left: 205px; margin-top: 6px;">
                                            <i class="icon-search"></i>
                                        </button>

                                        <!--–– txtFiltro ––-->
                                        <input type="text" name ="txtFiltro" placeholder="Ingresar consulta..." class="span3" style="left: 415px; top: -27px; height: 25px; margin-left: -246px; width: 195px; margin-top: 15px;">

                                        <!--–– btnReiniciarB ––-->
                                        <input class="btn btn-success btn-md" name="btnReiniciarB" type="submit" value = "Reiniciar búsqueda" style="  height: 30px; width: 150px; margin-left: 40px; margin-top: 6px;">

                                        <!--–– Filtros de búsqueda ––-->
                                        <div class="controls" style="margin-left: 113px; margin-top: -84px;">

                                            <!--–– Búsqueda por ID Producto ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad" id="ID Producto" value="ID Producto" checked=""> ID Producto
                                            </label>
                                            <!--–– Búsqueda por Nombre ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad"  id="Nombre" value="Nombre"> Nombre
                                            </label>
                                            <!--–– Búsqueda por Fabricante ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad"  id="Fabricante" value="Fabricante"> Fabricante
                                            </label>
                                            <!--–– Búsqueda por Categoría ––-->
                                            <label class="radio inline">
                                                <input type="radio" name="rad"  id="Categoria" value="Categoria"> Categoría
                                            </label>
                                        </div>
                                    </form>
                                </div>

                                <!--–– 1.2 Tabla Inventario ––-->
                                <div class="module-body" style="margin-top: 4px;"
                                     style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID Producto</th>
                                                <th>Nombre de producto</th>
                                                <th>Fabricante</th>
                                                <th>Categoria</th>
                                                <th>Precio</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    ArrayList<Producto> lProductos = dba.listarProductos(campo, filtro);
                                                    for (int i = 0; i < lProductos.size(); i++) {                                                       
                                            %>
                                            <tr>
                                                <td><%= lProductos.get(i).getId()%></td>
                                                <td><%= lProductos.get(i).getNombre()%></td>
                                                <td><%= lProductos.get(i).getFabricante()%></td>
                                                <td><%= lProductos.get(i).getCategoria()%></td>
                                                <td><%= lProductos.get(i).getPrecio()%> $</td>
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