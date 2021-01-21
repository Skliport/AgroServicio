
package Entidades;

import java.util.regex.Pattern;

public class ProductoPorVenta extends Producto {
    
    //Campos - Atributos.
    private int id_venta, cantidad;
    private double precioVenta;
    
    //Constructor.
    public ProductoPorVenta(){       
    }
    
    //Constructor / parámetros.
    public ProductoPorVenta(int id_venta, int id_producto, int cantidad, double precioVenta){
        this.id_venta = id_venta;
        this.id_producto = id_producto;
        this.cantidad = cantidad;
        this.precioVenta = precioVenta;
    }
    
    //Métodos de acceso - Set.
    public void setId_venta(String id_venta){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_venta)) {
            this.id_venta = Integer.parseInt(id_venta);
        } 
        else { System.out.println("Formato inválido (id_venta).");}     
    }
    
    public void setId_producto(String id_producto){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_producto)) {
            this.id_producto = Integer.parseInt(id_producto);
        } 
        else { System.out.println("Formato inválido (Id Producto - venta).");}     
    }
    
    public void setCantidad(String cantidad){
        
        //Enteros positivos * Max. Length = 5;
        if (Pattern.matches("^\\d{1,5}$", cantidad)) {
            this.cantidad = Integer.parseInt(cantidad);
        } 
        else { System.out.println("Formato inválido (Cantidad).");}     
    }
    
    public void setPrecioVenta(String precioVenta){
       
        //Double positivo.
        if (Pattern.matches("^([+]?[0-9]+)?([.|,]([0-9]{1,})?)?$", precioVenta)) {
            this.precioVenta = Double.parseDouble(precioVenta);
        } 
        else { System.out.println("Formato inválido (Precio venta).");}          
    }
    
    //Métodos de acceso - Get.
    public int getId_venta(){return this.id_venta;} 
    public int getId_producto(){return this.id_producto;} 
    public int getCantidad(){return this.cantidad;} 
    public double getPrecioVenta(){return this.precioVenta;}
}
