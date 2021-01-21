<%-- 
    Document   : registrar_venta
    Created on : May 10, 2019, 2:38:20 PM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*"%>
<%@page import="Entidades.DBAdmin"%> 
<%@page import="Entidades.Producto"%>
<%@page import="Entidades.ProductoPorVenta"%>
<%@page import="Entidades.Venta"%>

<% DBAdmin dba = (DBAdmin) pageContext.getAttribute("dba", pageContext.SESSION_SCOPE);%>

<%! Venta venta = new Venta(); boolean venta_activa; String id_venta;%> 
<%  ArrayList<Producto> lProductosDisponibles = dba.listarProductos("","");%> 
<%  String info = "", alerta = ""; boolean excepcion = false;
    
    try { //Agregar producto a pedido (lista temporal de productos por venta).
        if (request.getParameter("btnAgregarProducto") != null) {
            String id_producto = "", nombre, cantidad, precio, precioVenta;
       
            //Obtener atributos de producto.
            nombre = request.getParameter("nombre_producto");
            precio = request.getParameter("txtPrecioUnitario").substring(2);
            cantidad = request.getParameter("txtCantidad").trim();
            precioVenta = request.getParameter("txtPrecioVenta").substring(2);
            
            //Obtener id_producto.
            for (int i = 0; i < lProductosDisponibles.size(); i++) {
                if (lProductosDisponibles.get(i).getNombre().equals(nombre)) {
                    id_producto = Integer.toString(lProductosDisponibles.get(i).getId());
                }
            }

            //Verificando si el producto ha sido agregado antes. (En el pedido).
            for (int i = 0; i < venta.lProductosPorVenta.size(); i++) {
                if (venta.lProductosPorVenta.get(i).getNombre().toLowerCase().equals(nombre.toLowerCase())) {
                    excepcion = true; alerta += "Producto existente en pedido actual - ";
                }
            }

            //Verificando si id_venta es válido.
            try { if (Integer.parseInt(request.getParameter("txtId_Venta")) <= 0 ) {
                     excepcion = true; alerta += "Identificación de Venta no válida  - "; } 
            } catch(Exception ex) { excepcion = true; alerta += "Identificación de Venta no válida - ";}

            //Verificando si cantidad es válido.
            try{ Integer.parseInt(request.getParameter("txtCantidad")); }
            catch(Exception ex) { excepcion = true; alerta += "Cantidad no válida - "; }

            //Verificando que precio de venta no sea negativo o inexistente (0).
            if (Double.parseDouble(precioVenta) <= 0) {
                excepcion = true; alerta += "Venta negativa o inexistente - ";  
            }

            //Verificando id_venta no existente en lista de ventas.
            ArrayList<Venta> lVentas = dba.listarVentas("", "");
            for (int i = 0; i < lVentas.size(); i++) {
                if (request.getParameter("txtId_Venta").equals(Integer.toString(lVentas.get(i).getId_venta()))) {
                        excepcion = true; alerta += "Identificación de Venta existente - ";  
                }
            }

            //Agregar producto si no se encuentra ninguna excepción.
            if (excepcion == false) {
                venta.lProductosPorVenta.add(new ProductoPorVenta());
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setId_venta(request.getParameter("txtId_Venta"));
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setId(id_producto);
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setNombre(nombre);
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setPrecio(precio);
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setCantidad(cantidad);       
                venta.lProductosPorVenta.get(venta.lProductosPorVenta.size()-1).setPrecioVenta(precioVenta);
                
                //Producto agregado con éxito.
                venta_activa = true; id_venta = request.getParameter("txtId_Venta"); 
                info = "Nuevo producto con identificación: "+id_producto+" ha sido agregado al pedido.";
            }     
        }  
    }
    catch(Exception ex) {excepcion = true; alerta += "No ha sido posible realizar esta venta.";}

    try
    { //Registrar venta final.
        if (request.getParameter("btnRegistrarVenta") != null) {
         
           venta.setId_venta(id_venta); 
           dba.registrarVenta(venta);
           
           //Venta final registrada con éxito.
           info = "Última Venta con identificación: "+id_venta+" ha sio registrada con éxito."; 
           venta.lProductosPorVenta.clear(); venta_activa = false; id_venta = null;
        }  
    }
    catch(Exception ex) { excepcion = true; alerta = " No ha sido posible realizar esta venta";}  
       
    //Cancelar venta final.
    if (request.getParameter("btnCancelarVenta") != null) {
        info = "Última Venta con identificación: "+id_venta+"ha sio cancelada.";
        venta.lProductosPorVenta.clear(); venta_activa = false; id_venta = null;
    }
    
    //Remover producto de pedido actual.
    try { 
        if (request.getParameter("btnRemover") != null) {
            venta.lProductosPorVenta.remove(Integer.parseInt(request.getParameter("btnRemover")));
            info = "Producto removido del pedido.";
        }
    } catch(Exception ex) { } 
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Agroservicio - Registrar venta</title>
        <link type="text/css" href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="css/theme.css" rel="stylesheet">
        <link type="text/css" href="images/icons/css/font-awesome.css" rel="stylesheet">
        <link type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">
    </head>

    <body>
        <!--–– Panel superior ––-->
        <div class="navbar navbar-fixed-top">
                <div class="container">
                    <a class="brand" href="inventario.jsp"> Agroservicio / Panel de administración / Registro de ventas </a>
                </div>
        </div>

        <div class="wrapper" style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
            <div class="container">
                <div class="row">

                    <!--–– Barra de navegación - lateral ––-->
                    <div class="span3">
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

                    <!--–– 1. Panel Principal ––-->
                    <div class="span9">
                        <div class="content">

                            <!--–– 1.1 Ingreso de productos - Venta ––-->
                            <div class="module">
                                <div class="module-head" style="height: 27px;">
                                    <h3 style="margin-left: 3px; pointer-events: auto; width: 215px; margin-top: 6px;">Ingreso de datos:</h3>
                                </div>

                                <div class="module-body">
                                    <form class="form-horizontal row-fluid" action="registrar_venta.jsp" method="POST" name="Formulario_registro">

                                        <!–– ID Venta - txtId_Venta ––>
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">ID Venta:</label>
                                            <div class="controls">
                                                <div class="input-prepend">
                                                    <span class="add-on">#</span>
                                                    <input id="txtId_Venta" class="span8" name = "txtId_Venta" type="text" placeholder="Ingresar una identificación... " style="width: 219px;">
                                                </div>
                                            </div>
                                        </div>

                                        <!--–– Categoría - cmbProductos ––-->
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">Producto:</label>
                                            <div class="controls" style="width: 250px;">
                                                <select id="cmbProductos" name = "cmbProductos" class="span8" style="width: 246px;" onchange="getPrecioUnitario()" >
                                                    <option value = ""> Seleccionar un producto...</option>
                                                    <%
                                                        //Poblando - productos a seleccionar.
                                                        try { for (int i = 0; i < lProductosDisponibles.size(); i++) {                                                       
                                                     %>
                                                    <option value="<%= lProductosDisponibles.get(i).getPrecio()%>"> <%= lProductosDisponibles.get(i).getNombre()%> </option>       
                                                    <%
                                                            }
                                                        } catch(Exception ex) {}
                                                    %>
                                                </select>
                                                <input type="hidden" value ="" name = "nombre_producto" id="nombre_producto"/>
                                            </div>
                                            <br>

                                            <!--–– Cantidad - txtCantidad ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Cantidad:</label>
                                                <div class="controls">
                                                    <div class="input-prepend">
                                                        <span class="add-on">#</span>
                                                        <input id="txtCantidad" class="span8" name = "txtCantidad" type="text" placeholder="Ingresar una cantidad... " style="width: 218px;" onkeyup="getPrecioDeVenta()">
                                                    </div>
                                                </div>
                                            </div>
                                            <br>

                                            <!--–– Precio unitario - txtPrecioUnitario ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Precio unitario:</label>
                                                <div class="controls">
                                                    <div class="input-append">
                                                        <input id="txtPrecioUnitario" readonly type="text" name = "txtPrecioUnitario" value="$ 0.00" class="span8" style="width: 245px;">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                                  
                                        <!--–– Precio de venta - txtPrecioVenta ––-->
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">Precio de venta:</label>
                                            <div class="controls">
                                                <div class="input-append">
                                                    <input id="txtPrecioVenta" readonly type="text" name = "txtPrecioVenta" value="$ 0.00" class="span8" style="width: 100px;" >
                                                </div>
                                            </div>
                                        </div>

                                        <!--–– btn Agregar a pedido - btnAgregarProducto ––-->
                                        <div class="control-group">
                                            <div class="controls">
                                                <input id="btnAgregarProducto" class="btn btn-primary btn-md btn-block" name = "btnAgregarProducto" value ="Agregar a pedido" type="submit" style="width: 135px; margin-left: 110px; margin-top: -107px;">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!--––2. Pedido actual - Tabla temporal de productos ––-->
                            <div class="module">
                                <div class="module-head" style="height: 24px;">
                                    <h3 style="width: 250px; pointer-events: auto; margin-top: 4px; margin-left: 4px;">* Pedido actual/ Lista de productos: </h3>
                                </div>

                                <!--–– 2.1 Tabla temporal de productos ––-->
                                <div class="module-body" style="margin-top: 4px;"
                                     style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID Venta</th>
                                                <th>ID Producto</th>
                                                <th>Nombre</th>
                                                <th>Precio</th>
                                                <th>Cantidad</th>
                                                <th>Precio de venta</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try { for (int i = 0; i < venta.lProductosPorVenta.size(); i++) {                                                       
                                            %>
                                            <tr>
                                                <td><%=id_venta%></td>
                                                <td><%= venta.lProductosPorVenta.get(i).getId()%></td>
                                                <td><%= venta.lProductosPorVenta.get(i).getNombre()%></td>
                                                <td>$ <%= venta.lProductosPorVenta.get(i).getPrecio()%></td>
                                                <td><%= venta.lProductosPorVenta.get(i).getCantidad()%></td>
                                                <td>$ <%= venta.lProductosPorVenta.get(i).getPrecioVenta()%></td>
                                                <td><form action = "registrar_venta.jsp" method = "POST">
                                                        <button class="btn btn-danger btn-mini btn-block" name="btnRemover" value ="<%=i%>" type="submit"> Remover </button>                                     
                                                    </form> 
                                                </td>
                                                </tr>  
                                            <%
                                                    }
                                                } catch(Exception ex) {}
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!--––  3. Finalizar registro de venta ––-->
                            <div class="module">
                                <div class="module-head" style="height: 24px;">
                                    <h3 style="width: 138px; pointer-events: auto; margin-top: 4px; margin-left: 4px;">Finalizar registro:</h3>
                                </div>
                                <div class="module-body" style="margin-top: 4px; height: 90px;">

                                    <!--–– Formulario - Finalizar registro ––-->
                                    <form class="form-vertical" action = "registrar_venta.jsp" method = "POST" name = "Formulario_finalizar">
                                      
                                        <!--–– 3.1 Registrar venta final - btnRegistrarVenta. ––-->
                                        <div class="control-group">
                                            <div class="controls">
                                                <input class="btn btn-success btn-md btn-block" name = "btnRegistrarVenta" value="Registrar venta final" type="submit" style="margin-top: -5px; height: 40px">
                                            </div> <br>
                                        <!--–– 3.2 Cancelar registro - btnCancelarVenta. ––-->
                                        <div class="control-group">
                                            <div class="controls">
                                                <input class="btn btn-danger btn-md btn-block"  name = "btnCancelarVenta" value="Cancelar registro" type="submit" style="height: 40px">
                                            </div>
                                    </form>
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
            <%
            if (excepcion == false) {
            %>
                <div class="alert alert-success">
                > Usuario activo: <%= dba.getUsuario()%> <br>
                > <%= info%>
                </div>
            <%
            } else if (excepcion == true) {
            %>
                <div class="alert alert-error">
                    > Usuario activo: <%= dba.getUsuario()%> <br>
                    > <%= alerta%>
                </div>
            <%
            }
            %>  
        </div>
    </body>
</html>

<script>  
    try {
        //Obtener precios de venta.
        function getPrecioDeVenta() 
        {
            var precioU = document.getElementById("txtPrecioUnitario").value.substring(2);   
            var cantidad = document.getElementById("txtCantidad").value;
            var precioVenta =  precioU*cantidad;
            if (!(parseFloat(precioU) === 0) && !(isNaN(cantidad))){
               document.getElementById("txtPrecioVenta").value="$ " + precioVenta.toFixed(2);
            }
        }

        //Obtener precio unitario.
        function getPrecioUnitario(){
            var cmb = document.getElementById("cmbProductos");
            var precio = cmb.options[cmb.selectedIndex].value;
            
            document.getElementById("txtPrecioUnitario").value="$ " + precio;
            document.getElementById("nombre_producto").value = cmb.options[cmb.selectedIndex].text;
            cmb.blur(); getPrecioDeVenta();
            
            if (cmb.options[cmb.selectedIndex].text === "Seleccionar un producto...") {
                document.getElementById("txtPrecioVenta").value="$ 0.00";
                document.getElementById("txtPrecioUnitario").value="$ 0.00";
            }
        }
        
        //Estado de venta - activa.
        function definir_VentaActiva(){
            document.getElementById("txtId_Venta").readOnly = true;
            document.getElementById("txtId_Venta").value = <%=id_venta%>;
        }
        
        //Estado de venta - no activa.
        function restablecer_VentaActiva(){
            document.getElementById("txtId_Venta").readOnly = false;
            document.getElementById("txtId_Venta").value = null;
        }
    }
    catch(ex) {
    }
 </script>
  
 <% //Definiendo estado de venta.
    if (venta_activa == true) { %>
    <script type="text/javascript">
        definir_VentaActiva();
    </script>
<% } %>
<%  if (venta_activa == false) { %>
    <script type="text/javascript">
        restablecer_VentaActiva();
    </script>
<% } %>