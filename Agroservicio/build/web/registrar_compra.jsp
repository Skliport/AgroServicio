<%-- 
    Document   : registrar_compra
    Created on : May 10, 2019, 2:38:05 PM
--%>

<%@page import="java.util.regex.Pattern"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*"%>
<%@page import="Entidades.DBAdmin"%> 
<%@page import="Entidades.Producto"%>
<%@page import="Entidades.ProductoPorCompra"%>
<%@page import="Entidades.Compra"%>

<% DBAdmin dba = (DBAdmin) pageContext.getAttribute("dba", pageContext.SESSION_SCOPE);%>

<%! Compra compra = new Compra(); boolean compra_activa; String id_compra;%> 
<%  String info = "", alerta = ""; boolean excepcion = false;
    
    try { //Agregar producto a pedido (lista temporal de productos por compra).
        if (request.getParameter("btnAgregarProducto") != null) {
            String id_producto = "", nombre, fabricante, categoria, precio, cantidad, precioCompra;
        
            //Obtener atributos de producto.
            id_compra = request.getParameter("txtId_Compra").trim();
            id_producto = request.getParameter("txtId_Producto").trim();
            nombre = request.getParameter("txtNombre");
            fabricante = request.getParameter("txtFabricante");
            categoria = request.getParameter("txtCategoria");
            precio = request.getParameter("txtPrecioUnitario").substring(1).trim();
            cantidad = request.getParameter("txtCantidad").trim();
            precioCompra = request.getParameter("txtPrecioCompra").substring(2);
            
            //Verificando id_compra válido.
            try { if (Integer.parseInt(request.getParameter("txtId_Compra")) <= 0 ) {
                  excepcion = true; alerta += "Identificación de Compra no válida - "; } 
            } catch(Exception ex) { excepcion = true; alerta += "Identificación de Compra no válida - "; }
            
            //Verificando id_producto/ nombre de producto no existente en inventario.
            ArrayList<Producto> lProductosDisponibles = dba.listarProductos("","");
            for (int i = 0; i < lProductosDisponibles.size(); i++) {
                if (request.getParameter("txtId_Producto").equals(Integer.toString(lProductosDisponibles.get(i).getId()))) {
                        excepcion = true; alerta += "Identificación de producto existente en inventario - ";  
                }
                if (request.getParameter("txtNombre").equals(lProductosDisponibles.get(i).getNombre())) {
                        excepcion = true; alerta += "Nombre de producto existente en inventario - ";  
                }
            }
            
            //Verificando id_producto válido.
            try { if (Integer.parseInt(request.getParameter("txtId_Producto")) <= 0 ) {
                    excepcion = true; alerta += "Identificación de producto no válida - "; } 
            } catch(Exception ex) { excepcion = true; alerta += "Identificación de producto no válida - "; }
            
            
            //Verificando nombre/id de producto existente en pedido.
            for (int i = 0; i < compra.lProductosPorCompra.size(); i++) {
                if (compra.lProductosPorCompra.get(i).getNombre().toLowerCase().equals(nombre.toLowerCase())) {
                    excepcion = true; alerta += "Nombre de producto existente en pedido actual - ";
                }
                if (compra.lProductosPorCompra.get(i).getId_producto() == Integer.parseInt(id_producto)) {
                    excepcion = true; alerta += "Identificación de producto existente en pedido actual - ";
                }
            }
       
            //Verificando nombre válido.
            if (!(Pattern.matches("^[_A-z0-9]*((-|\\s)*[_A-z0-9])*$", nombre)) 
                || !(Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", nombre))) {
                    excepcion = true; alerta += "Nombre de producto no válido - "; 
            } 
            try{ Double.parseDouble(nombre); excepcion = true; alerta += "Nombre de producto no válido - ";}
            catch(Exception ex) {}
 
            //Verificando fabricante válido.
            if (!(Pattern.matches("^[_A-z0-9]*((-|\\s)*[_A-z0-9])*$", fabricante)) 
                || !(Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", fabricante))) {
                    excepcion = true; alerta += "Fabricante no válido - "; 
            } 
            try{ Double.parseDouble(fabricante); excepcion = true; alerta += "Fabricante no válido - ";}
            catch(Exception ex) {}
             
            //Verificando categoria válida.
            if (!(Pattern.matches("^[_A-z0-9]*((-|\\s)*[_A-z0-9])*$", categoria)) 
                || !(Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", categoria))) {
                    alerta += "Categoría no válida - "; 
            } 
            try{ Double.parseDouble(categoria); excepcion = true; alerta += "Categoría no válida - ";}
            catch(Exception ex) {}
            
            //Verificando precio válido.
            try{ Double.parseDouble(precio); }
            catch(Exception ex) { excepcion = true; alerta += "Precio no válido - "; }
            
            //Verificando cantidad válida.
            try{ Integer.parseInt(request.getParameter("txtCantidad").trim()); }
            catch(Exception ex) { excepcion = true; alerta += "Cantidad no válida - "; }
            
            //Verificando precioCompra válido. Negativo o compra inexistente.
              if (Double.parseDouble(precioCompra) <= 0) {
                excepcion = true; alerta += "Venta negativa o inexistente - ";  
            }
            
            //Verificando id_compra no existente en lista de compras.
            ArrayList<Compra> lCompras = dba.listarCompras("", "");
            for (int i = 0; i < lCompras.size(); i++) {
                if (request.getParameter("txtId_Compra").equals(Integer.toString(lCompras.get(i).getId_compra()))) {
                    excepcion = true; alerta += "Identificación de compra existe - ";  
                }
            }
            
            //Agregar producto si no se encuentra ninguna excepción.
            if (excepcion == false) {
                compra.lProductosPorCompra.add(new ProductoPorCompra());
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setId_compra(request.getParameter("txtId_Compra").trim());
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setId(id_producto);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setNombre(nombre);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setFabricante(fabricante);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setCategoria(categoria);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setPrecio(precio);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setCantidad(cantidad);
                compra.lProductosPorCompra.get(compra.lProductosPorCompra.size()-1).setPrecioCompra(precioCompra);
              
                //Producto agregado con éxito.
                info = "Nuevo producto con identificación: "+id_producto+" ha sido agregado al pedido.";
                compra_activa = true; id_compra = request.getParameter("txtId_Compra").trim(); 
            } 
        }  
    }
    catch(Exception ex) {excepcion = true; alerta += "No ha sido posible agregar producto a pedido.";}

    try
    { //Registrar compra final.
        if (request.getParameter("btnRegistrarCompra") != null) {
         
            compra.setId_compra(id_compra);
            dba.registrarCompra(compra);
            
           //Compra final registrada con éxito.
            info = "Última compra con identificación: "+id_compra+" ha sio registrada con éxito.";
            compra.lProductosPorCompra.clear(); compra_activa = false; id_compra = null;
        }  
    }
    catch(Exception ex) { excepcion = true; alerta = " No ha sido posible realizar esta compra.";}  
       
    //Cancelar compra final.
    if (request.getParameter("btnCancelarCompra") != null) {
         info = "Última compra con identificación: "+id_compra+"ha sio cancelada.";
        compra.lProductosPorCompra.clear(); compra_activa = false; id_compra = null;
    } 

    //Remover producto de pedido actual.
    try { 
        if (request.getParameter("btnRemover") != null) {
            compra.lProductosPorCompra.remove(Integer.parseInt(request.getParameter("btnRemover")));
            info = "Producto removido del pedido.";
        }
    } catch(Exception ex) { }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Agroservicio - Registrar compra</title>
        <link type="text/css" href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="css/theme.css" rel="stylesheet">
        <link type="text/css" href="images/icons/css/font-awesome.css" rel="stylesheet">
        <link type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">
    </head>

    <body>
        <!--–– Panel superior ––-->
        <div class="navbar navbar-fixed-top">
                <div class="container">
                    <a class="brand" href="inventario.jsp"> Agroservicio / Panel de administración / Registro de compras </a>
                </div>
        </div>

        <div class="wrapper" style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
            <div class="container">
                <div class="row" style="margin-top: 1px;">

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

                    <!--–– 1. Panel principal ––-->
                    <div class="span9">
                        <div class="content" >

                            <!--–– 1.1 Ingreso de productos - Compra ––-->
                            <div class="module">
                                <div class="module-head" style="height: 27px;">
                                    <h3 style="margin-left: 3px; pointer-events: auto; width: 215px; margin-top: 6px;">Ingreso de datos:</h3>
                                </div>
                                <div class="module-body">
                                    
                                    <!--–– Formulario de registro ––-->
                                    <form class="form-horizontal row-fluid" action="registrar_compra.jsp" method="POST" name="Formulario_registro">

                                        <!--–– ID Compra - txtId_Compra ––-->
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">ID Compra:</label>
                                            <div class="controls">
                                                <div class="input-prepend">
                                                    <span class="add-on">#</span>
                                                    <input class="span8"  id = "txtId_Compra"  name = "txtId_Compra" type="text" placeholder="Ingresar una identificación... " style="width: 205px;">
                                                </div>
                                            </div>
                                        </div>

                                        <!--–– ID Producto -  txtId_Producto ––-->
                                        <div class="control-group">        
                                            <label class="control-label" for="basicinput">ID Producto:</label>
                                            <div class="controls">
                                                <div class="input-prepend">
                                                    <span class="add-on">#</span>
                                                    <input class="span8" id = "txtId_Producto"  name = "txtId_Producto" type="text" placeholder="Ingresar una identificación... " style="width: 206px;">
                                                </div>
                                            </div>
                                            <br>

                                            <!--–– Nombre - txtNombre ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Nombre:</label>
                                                <div class="controls">
                                                    <input type="text" id="txtNombre"  name="txtNombre" placeholder="Ingresar un nombre..." class="span8" style="width: 233px;">
                                                </div>
                                            </div>
                                            <br>

                                            <!--–– Fabricante - txtFabricante ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Fabricante:</label>
                                                <div class="controls">
                                                    <input type="text" id="txtFabricante" name="txtFabricante" placeholder="Ingresar un fabricante..." class="span8" style="width: 234px;">
                                                </div>
                                            </div>
                                            <br>

                                            <!--–– Categoría - txtCategoria ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Categoría:</label>
                                                <div class="controls">
                                                    <input type="text" id="txtCategoria"  name="txtCategoria" placeholder="Ingresar una categoría..." class="span8" style="width: 233px;">
                                                </div>
                                            </div>
                                            <br>

                                            <!--–– Precio unitario - txtPrecioUnitario ––-->
                                            <div class="control-group">
                                                <label class="control-label" for="basicinput">Precio unitario:</label>
                                                <div class="controls">
                                                    <div class="input-append">
                                                        <input type="text" id = "txtPrecioUnitario" name = "txtPrecioUnitario" value="$ 0.00" class="span8" style="left: -1px;width: 235px;"  onkeyup="setPrecio()" >
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!--–– Cantidad - txtCantidad ––-->
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">Cantidad:</label>
                                            <div class="controls">
                                                <div class="input-prepend">
                                                    <span class="add-on">#</span>
                                                    <input class="span8" id = "txtCantidad"  name = "txtCantidad" type="text" placeholder="Ingresar una cantidad... " style="width: 208px; left: 1px;" onkeyup="getPrecioDeCompra()"> 
                                                </div>
                                            </div>
                                        </div>

                                        <!--–– Precio de compra - txtPrecioCompra ––-->
                                        <div class="control-group">
                                            <label class="control-label" for="basicinput">Precio de compra:</label>
                                            <div class="controls">
                                                <div class="input-append">
                                                    <input type="text"  id = "txtPrecioCompra" name = "txtPrecioCompra" value="$ 0.00" class="span8" readonly = true style="width: 105px;" >
                                                </div>
                                            </div>

                                            <!--–– btn Agregar a pedido - btnAgregarProducto ––-->
                                            <div class="control-group">
                                                <div class="controls">
                                                    <input class="btn btn-primary btn-md btn-block" name = "btnAgregarProducto" type="submit" value = "Agregar a pedido" style="width: 125px; margin-left: 112px; margin-top: -54px;">
                                                </div>
                                            </div>
                                            <div class="control-group"></div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!--–– 2. Pedido actual - Tabla temporal de productos ––-->
                            <div class="module">
                                <div class="module-head" style="height: 24px;">
                                    <h3 style="width: 250px; pointer-events: auto; margin-top: 4px; margin-left: 4px;">* Pedido actual - Lista de productos: </h3>
                                </div>

                                <!--–– 2.1 Tabla temporal de productos ––-->
                                <div class="module-body" style="margin-top: 4px;"
                                     style=" position:relative; margin:auto; width:100%;  height: calc(100% - 2px);">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID/Compra</th>
                                                <th>ID/Producto</th>
                                                <th>Nombre</th>
                                                <th>Fabricante</th>
                                                <th>Categoria</th>
                                                <th>Precio</th>
                                                <th>Cantidad</th>
                                                <th>Precio de compra</th>
                                                <th> </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try { for (int i = 0; i < compra.lProductosPorCompra.size(); i++) {                                                       
                                            %>
                                            <tr>
                                                <td><%=id_compra%></td>
                                                <td><%= compra.lProductosPorCompra.get(i).getId()%></td>
                                                <td><%= compra.lProductosPorCompra.get(i).getNombre()%></td>
                                                <td><%= compra.lProductosPorCompra.get(i).getFabricante()%></td>
                                                <td><%= compra.lProductosPorCompra.get(i).getCategoria()%></td>
                                                <td>$ <%= compra.lProductosPorCompra.get(i).getPrecio()%></td>
                                                <td><%= compra.lProductosPorCompra.get(i).getCantidad()%></td>
                                                <td>$ <%= compra.lProductosPorCompra.get(i).getPrecioCompra()%></td>
                                                <td><form action = "registrar_compra.jsp" method = "POST">
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

                            <!--–– 3. Finalizar registro de compra ––-->
                            <div class="module">
                                <div class="module-head" style="height: 24px;">
                                    <h3 style="pointer-events: auto; margin-top: 4px; margin-left: 4px; width: 201px;">Finalizar registro:</h3>
                                </div>
                                <div class="module-body" style="margin-top: 4px; height: 90px;">

                                    <!--––Formulario - Finalizar registro ––-->
                                    <form class="form-vertical" action = "registrar_compra.jsp" method = "POST" name = "Formulario_finalizar">
                                      
                                        <!--–– 3.1 Registrar compra final - btnRegistrarCompra. ––-->
                                        <div class="control-group">
                                            <div class="controls">
                                                <input class="btn btn-success btn-md btn-block" name = "btnRegistrarCompra" value = "Registrar compra final" type="submit" style="margin-top: -5px; height: 40px">
                                            </div><br>

                                        <!--–– 3.2 Cancelar registro - btnCancelarCompra. ––-->
                                        <div class="control-group">
                                            <div class="controls">
                                                <input class="btn btn-danger btn-md btn-block" name = "btnCancelarCompra" value ="Cancelar registro" type="submit" style="height: 40px">
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
        //Obtener precios de compra.
        function getPrecioDeCompra() 
        {
            var precioU = document.getElementById("txtPrecioUnitario").value.substring(1).trim();   
            var cantidad = document.getElementById("txtCantidad").value;
            var precioCompra =  precioU*cantidad;
            if (!(parseFloat(precioU) === 0) && !(isNaN(cantidad)) && !(isNaN(precioU))){
               document.getElementById("txtPrecioCompra").value="$ " + precioCompra.toFixed(2);
            }
        }
 
        function setPrecio() 
        {
           var precioU = document.getElementById("txtPrecioUnitario").value;   
            if (!(precioU.charAt(0) === "$")) {
                document.getElementById("txtPrecioUnitario").value="$ " + precioU; 
                
                }      this.getPrecioDeCompra();
        }
        
        //Estado de compra - activa.
        function definir_CompraActiva(){
            document.getElementById("txtId_Compra").readOnly = true;
            document.getElementById("txtId_Compra").value = <%=id_compra%>;
        }
        
        //Estado de compra - no activa.
        function restablecer_CompraActiva(){
            document.getElementById("txtId_Compra").readOnly = false;
            document.getElementById("txtId_Compra").value = null;
        }
    }
    catch(ex) {
    }
 </script>
 
 <% //Definiendo estado de compra.
    if (compra_activa == true) { %>
    <script type="text/javascript">
        definir_CompraActiva();
    </script>
<% } %>
<%  if (compra_activa == false) { %>
    <script type="text/javascript">
        restablecer_CompraActiva();
    </script>
<% } %>