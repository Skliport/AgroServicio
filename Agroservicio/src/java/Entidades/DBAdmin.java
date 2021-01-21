
package Entidades;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class DBAdmin {
    
    //Atributos / Campos.
    private String usuario, password;
    private String db = "jdbc:mysql://localhost:3306/db_agroservicio";
    public Connection conexion = null;
    
    SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
    
    //Constructor.
    public DBAdmin(){
    }
    
    //Constructor - Conexión inicial.
    public DBAdmin(String usuario, String password) throws ClassNotFoundException,
           InstantiationException, IllegalAccessException{
        
        this.usuario = usuario; this.password = password;
     
        try
        {
            //Instanciar conexión.
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            this.conexion = DriverManager.getConnection(this.db, this.usuario, this.password);
        }
        catch(SQLException ex){System.out.println(ex);} 
    }
    
    //1. Registrar producto.
    public void registrarProducto(Producto producto) throws SQLException{
        
        //Conectando.
        this.conectar();
        
        //Sentencia SQL del comando.
        String comando = "INSERT INTO `db_agroservicio`.`productos` (`id_producto`, `nombre`, `fabricante`,"
                + "`categoria`, `precio`) VALUES ('"+ producto.getId() +"', '"+ producto.getNombre()+"', "
                + "'"+ producto.getFabricante()+"', '"+ producto.getCategoria() +"', '"+ producto.getPrecio() +"');";
        
        //Ejecutando el comando.
        this.ejecutarComando(comando);
        
        //Cerrando la conexión.
        this.cerrarConexion();
    }
    
    //2. Registrar venta.
    public void registrarVenta(Venta venta) throws SQLException{
        
        //Conectando.
        this.conectar();
        
         // A) Agregar venta a VENTAS. 
        String comando = "INSERT INTO `db_agroservicio`.`ventas` (`id_venta`, `fecha`) VALUES "
                + "('"+ venta.getId_venta()+"', '"+ sdf.format(venta.getFecha()) +"');";
        
        //Ejecutando el comando.
        this.ejecutarComando(comando);
        
        // B) Agregar productos a PRODUCTOS_VENTAS.
        for (int i = 0; i < venta.lProductosPorVenta.size(); i++) {
           
            String comando2 = "INSERT INTO `db_agroservicio`.`productos_ventas` (`id_venta`, `id_producto`, `cantidad`,"
                + "`precio_venta`) VALUES ('"+  venta.lProductosPorVenta.get(i).getId_venta()+"', '"+  venta.lProductosPorVenta.get(i).getId_producto()+"', "
                + "'"+  venta.lProductosPorVenta.get(i).getCantidad() +"', '"+  venta.lProductosPorVenta.get(i).getPrecioVenta()+"');";
        
            this.ejecutarComando(comando2);
        }
        
        //Cerrando la conexión.
        this.cerrarConexion();
    }
    
    //3. Registrar compra.
    public void registrarCompra(Compra compra) throws SQLException{
        
        //Conectando.
        this.conectar();
        
         // A) Agregar compra a COMPRAS. 
        String comando = "INSERT INTO `db_agroservicio`.`compras` (`id_compra`, `fecha`) VALUES "
                + "('"+ compra.getId_compra()+"', '"+ sdf.format(compra.getFecha()) +"');";
        
        //Ejecutando comando.
        this.ejecutarComando(comando);
        
        // B) Agregar productos.
        for (int i = 0; i < compra.lProductosPorCompra.size(); i++) {
            this.registrarProducto(compra.lProductosPorCompra.get(i));
        }
        
        //Conectando.
        this.conectar();
        
        // C) Agregar productos a PRODUCTOS_COMPRAS.
        for (int i = 0; i < compra.lProductosPorCompra.size(); i++) {
           
            String comando2 = "INSERT INTO `db_agroservicio`.`productos_compras` (`id_compra`, `id_producto`, `cantidad`,"
                + "`precio_compra`) VALUES ('"+  compra.lProductosPorCompra.get(i).getId_compra()+"', '"+  compra.lProductosPorCompra.get(i).getId_producto()+"', "
                + "'"+  compra.lProductosPorCompra.get(i).getCantidad() +"', '"+  compra.lProductosPorCompra.get(i).getPrecioCompra()+"');";
        
            this.ejecutarComando(comando2);
        }
        
        //Cerrando la conexión.
        this.cerrarConexion();
    }
    
    //4. Remover producto.
    public void removerProducto(int id_producto) throws SQLException{
        
        //Conectando.
        this.conectar();
        
        //Sentencia SQL del comando.
        String comando = "DELETE FROM `db_agroservicio`.`productos` WHERE "
                + "(`id_producto` = '"+ id_producto +"');";
        
        //Ejecutando el comando.
        this.ejecutarComando(comando);
        
        //Cerrando la conexión.
        this.cerrarConexion();
    }
     
//    //Recuperar valor de campo específico en tabla específica.
//    public String getValorCampo(String campo, String tabla, String id) throws SQLException{
//       
//        //Conectando.
//        this.conectar();
//        
//        String valor = "";
//        
//        //Sentencia SQL de la consulta.
//        String consulta = "SELECT `" + campo + "` FROM `"+ tabla +"` WHERE (`id_producto` ='"+ id +"');";
//        
//        //Obteniendo el ResultSet.
//        ResultSet rs = this.ejecutarConsulta(consulta);
//            
//        //Mostrando el contenido del ResultSet
//        while(rs.next())
//        {
//            valor = rs.getString(campo); 
//        }
//        
//        //Cerrando la conexión.
//        this.cerrarConexion();
//       
//        //Retornando valor del campo.
//        return valor;
//    }
    
    //5. Listar productos.
    public ArrayList listarProductos(String campo, String filtro) throws SQLException{
  
        //Lista de productos.
        ArrayList<Producto> lProductos = new ArrayList<>();
         
        //Conectando.
        this.conectar();
        
        //Sentencia SQL de la consulta
        String consulta = "SELECT * FROM `productos`;";
        
        switch (campo) {
            case "id_producto":  
                consulta = "SELECT * FROM `productos` WHERE (`id_producto` = '"+filtro+"');";
                break;
            case "nombre": 
                consulta = "SELECT * FROM `productos` WHERE (`nombre` LIKE '%"+filtro+"%');";
                break;   
            case "fabricante":
                consulta = "SELECT * FROM `productos` WHERE (`fabricante` LIKE '%"+filtro+"%');";
                break;
            case "categoria":
                consulta = "SELECT * FROM `productos` WHERE (`categoria` LIKE '%"+filtro+"%');";
                break;
        }
        
        //Obteniendo ResultSet.
        ResultSet rs = this.ejecutarConsulta(consulta);
        
        //Mostrando contenido del ResultSet.
        while(rs.next())
        {
           lProductos.add(new Producto());
           lProductos.get(lProductos.size()-1).setId(rs.getString("id_producto"));
           lProductos.get(lProductos.size()-1).setNombre(rs.getString("nombre"));
           lProductos.get(lProductos.size()-1).setFabricante(rs.getString("fabricante"));
           lProductos.get(lProductos.size()-1).setCategoria(rs.getString("categoria"));
           lProductos.get(lProductos.size()-1).setPrecio(rs.getString("precio")); 
        }
        
        //Cerrar conexión.
        this.cerrarConexion();
        
        //Retorna lista de productos.
        return lProductos; 
    }   
    
    //6. Listar compras.
    public ArrayList listarCompras(String campo, String filtro) throws SQLException{
  
        //Lista de compras.
        ArrayList<Compra> lCompras = new ArrayList<>();
         
        //Conectando.
        this.conectar();
        
        //Sentencia SQL de la consulta
        String consulta = "SELECT * FROM `compras`;";
        
        switch (campo) {
            case "id_compra":  
                consulta = "SELECT * FROM `compras` WHERE (`id_compra` = '"+filtro+"');";
                break;
            case "fecha": 
                consulta = "SELECT * FROM `compras` WHERE (`fecha` LIKE '"+filtro+"%');";
        }
        
        //Obteniendo ResultSet.
        ResultSet rs = this.ejecutarConsulta(consulta);
        
        //Mostrando contenido del ResultSet.
        while(rs.next())
        {
           lCompras.add(new Compra());
           lCompras.get(lCompras.size()-1).setId_compra(rs.getString("id_compra"));
           lCompras.get(lCompras.size()-1).setFecha(rs.getTimestamp("fecha"));
        }
        
        //Cerrar conexión.
        this.cerrarConexion();
        
        //Retorna lista de compras.
        return lCompras; 
    }   
    
    //7. Listar productos por compra
    public ArrayList listarProductos_compra(String id_compra) throws SQLException{
  
        //Lista de compras.
        ArrayList<ProductoPorCompra> lProductosPorCompra = new ArrayList<>();
        
        //Conectando.
        this.conectar();
        
        //Sentencia SQL de la consulta
        String consulta = "SELECT productos_compras.id_compra, productos_compras.id_producto, productos.nombre, "
                + "productos_compras.cantidad, productos.precio, productos_compras.precio_compra"
                + " FROM productos_compras Inner join productos on productos_compras.id_producto"
                + " = productos.id_producto where (id_compra ='"+ id_compra +"');";
        
        //Obteniendo el ResultSet.
        ResultSet rs = this.ejecutarConsulta(consulta);
       
        //Mostrando el contenido del ResultSet
        while(rs.next())
        {
            lProductosPorCompra.add(new ProductoPorCompra());
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setId_compra(rs.getString("id_compra"));
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setId_producto(rs.getString("id_producto"));
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setNombre(rs.getString("nombre"));
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setCantidad(rs.getString("cantidad"));
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setPrecio(rs.getString("precio"));
            lProductosPorCompra.get(lProductosPorCompra.size()-1).setPrecioCompra(rs.getString("precio_compra"));
        }
        
        //Cerrar conexión.
        this.cerrarConexion();
        
        //Retornar lista de productos por compra.
        return lProductosPorCompra;
    }
    
    //8. Listar ventas.
    public ArrayList listarVentas(String campo, String filtro) throws SQLException{
  
        //Lista de compras.
        ArrayList<Venta> lVentas = new ArrayList<>();
         
        //Conectando.
        this.conectar();
        
        //Sentencia SQL de la consulta
        String consulta = "SELECT * FROM `ventas`;";
        
        switch (campo) {
            case "id_venta":  
                consulta = "SELECT * FROM `ventas` WHERE (`id_venta` = '"+filtro+"');";
                break;
            case "fecha": 
                consulta = "SELECT * FROM `ventas` WHERE (`fecha` LIKE '"+filtro+"%');";
        }
        
        //Obteniendo ResultSet.
        ResultSet rs = this.ejecutarConsulta(consulta);
        
        //Mostrando contenido del ResultSet.
        while(rs.next())
        {
           lVentas.add(new Venta());
           lVentas.get(lVentas.size()-1).setId_venta(rs.getString("id_venta"));
           lVentas.get(lVentas.size()-1).setFecha(rs.getTimestamp("fecha"));
        }
        
        //Cerrar conexión.
        this.cerrarConexion();
        
        //Retorna lista de compras.
        return lVentas; 
    }  
    
    //9. Listar productos por venta
    public ArrayList listarProductos_venta(String id_venta) throws SQLException{
  
        //Lista de compras.
        ArrayList<ProductoPorVenta> lProductosPorVenta = new ArrayList<>();
        
        //Conectando.
        this.conectar();
        
        //Sentencia SQL de la consulta
        String consulta = "SELECT productos_ventas.id_venta, productos_ventas.id_producto, productos.nombre, "
                + "productos_ventas.cantidad, productos.precio, productos_ventas.precio_venta"
                + " FROM productos_ventas Inner join productos on productos_ventas.id_producto"
                + " = productos.id_producto where (id_venta ='"+ id_venta +"');";
        
        //Obteniendo el ResultSet.
        ResultSet rs = this.ejecutarConsulta(consulta);
       
        //Mostrando el contenido del ResultSet
        while(rs.next())
        {
            lProductosPorVenta.add(new ProductoPorVenta());
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setId_venta(rs.getString("id_venta"));
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setId_producto(rs.getString("id_producto"));
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setNombre(rs.getString("nombre"));
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setCantidad(rs.getString("cantidad"));
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setPrecio(rs.getString("precio"));
            lProductosPorVenta.get(lProductosPorVenta.size()-1).setPrecioVenta(rs.getString("precio_venta"));
        }
        
        //Cerrar conexión.
        this.cerrarConexion();
        
        //Retornar lista de productos por venta.
        return lProductosPorVenta;
    }
        
    //Conectar.
    public void conectar() {
        try
        {
            this.conexion = DriverManager.getConnection(this.db, this.usuario, this.password);
        }
        catch(SQLException ex){System.out.println(ex);} 
    }
    
    //Ejecución de comandos.
    public void ejecutarComando(String comando) throws SQLException {

        try 
        {
            Statement com = this.conexion.createStatement(); //Objeto Statement.
    
            com.executeUpdate(comando); //Ejecución.
            System.out.println("Efectuado con éxito.");
        }
        catch(SQLException ex) {System.out.println(ex);}
    }
    
    //Ejecución de consultas.
    public ResultSet ejecutarConsulta(String consulta) throws SQLException{
   
        Statement cons = this.conexion.createStatement();  //Objeto tipo statement que maneja la consulta.
        return cons.executeQuery(consulta); //Ejecutando la consulta.
    }
    
    //Cerrar conexión db.
    public void cerrarConexion() throws SQLException {
        this.conexion.close();
    }
    
    //Métodos de acceso - Set.
    public void setUsuario(String usuario){
            this.usuario = usuario;   
    }
    
    public void setPassword(String password){
            this.password = password;   
    }
    
    //Métodos de acceso - Get.
    public Connection getConexion(){return this.conexion;} 
    public String getUsuario(){return this.usuario;} 
}