
package Entidades;

import java.util.regex.Pattern;

public class Producto {
    
    //Campos - Atributos.
    protected int id_producto;
    protected String nombre, fabricante, categoria;
    protected double precio;
    
    //Constructor.
    public Producto(){       
    }
    
    //Constructor / parámetros.
    public Producto(int id_producto, String nombre, String fabricante, String categoria, double precio){
        this.id_producto = id_producto;
        this.nombre = nombre;
        this.fabricante = fabricante;
        this.categoria = categoria;
        this.precio = precio;
    }
    
    //Métodos de acceso - Set.
    public void setId(String id_producto){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_producto)) {
            this.id_producto = Integer.parseInt(id_producto);
        } 
        else { System.out.println("Formato inválido (ID producto).");}     
    }
    
    public void setNombre(String nombre){
        
        //General * No espacio en blanco al inicio.
        if (Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", nombre)) {
            this.nombre = nombre;
        } 
        else { System.out.println("Formato inválido (Nombre).");}   
    }
    
    public void setFabricante(String fabricante){
        
        //General * No espacio en blanco al inicio.
        if (Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", fabricante)) {
            this.fabricante = fabricante;
        } 
        else { System.out.println("Formato inválido (Fabricante).");}  
    }
    
    public void setCategoria(String categoria){
        
        //General * No espacio en blanco al inicio.
        if (Pattern.matches("^[^\\s]+(\\s+[^\\s]+)*$", categoria)) {
            this.categoria = categoria;
        } 
        else { System.out.println("Formato inválido (Categoria).");} 
    }
    
    public void setPrecio(String precio){
       
        //Double positivo.
        if (Pattern.matches("^([+]?[0-9]+)?([.|,]([0-9]{1,})?)?$", precio)) {
            this.precio = Double.parseDouble(precio);
        } 
        else { System.out.println("Formato inválido (Precio producto).");}    
    }
    
    //Métodos de acceso - Get.
    public int getId(){return this.id_producto;} 
    public String getNombre(){return this.nombre;}
    public String getFabricante(){return this.fabricante;}
    public String getCategoria(){return this.categoria;}
    public double getPrecio(){return this.precio;}
}