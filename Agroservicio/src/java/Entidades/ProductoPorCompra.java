
package Entidades;

import java.util.regex.Pattern;

public class ProductoPorCompra extends Producto{
    
    //Campos - Atributos.
    private int id_compra, cantidad;
    private double precioCompra;
    
    //Constructor.
    public ProductoPorCompra(){       
    }
    
    //Constructor / parámetros.
    public ProductoPorCompra(int id_compra, int id_producto, int cantidad, double precioCompra){
        this.id_compra = id_compra;
        this.id_producto = id_producto;
        this.cantidad = cantidad;
        this.precioCompra = precioCompra;
    }
    
    //Métodos de acceso - Set.
    public void setId_compra(String id_compra){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_compra)) {
            this.id_compra = Integer.parseInt(id_compra);
        } 
        else { System.out.println("Formato inválido (id_compra).");}     
    }
    
    public void setId_producto(String id_producto){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_producto)) {
            this.id_producto = Integer.parseInt(id_producto);
        } 
        else { System.out.println("Formato inválido (Id Producto - compra).");}     
    }
    
    public void setCantidad(String cantidad){
        
        //Enteros positivos * Max. Length = 5;
        if (Pattern.matches("^\\d{1,5}$", cantidad)) {
            this.cantidad = Integer.parseInt(cantidad);
        } 
        else { System.out.println("Formato inválido (Cantidad).");}     
    }
    
    public void setPrecioCompra(String precioCompra){
       
        //Double positivo.
        if (Pattern.matches("^([+]?[0-9]+)?([.|,]([0-9]{1,})?)?$", precioCompra)) {
            this.precioCompra = Double.parseDouble(precioCompra);
        } 
        else { System.out.println("Formato inválido (Precio compra).");}          
    }
    
    //Métodos de acceso - Get.
    public int getId_compra(){return this.id_compra;} 
    public int getId_producto(){return this.id_producto;} 
    public int getCantidad(){return this.cantidad;} 
    public double getPrecioCompra(){return this.precioCompra;} 
}