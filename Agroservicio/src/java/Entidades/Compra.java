
package Entidades;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.regex.Pattern;

public class Compra {
    
    //Campos - Atributos.
    private int id_compra;
    private Date fecha;
    public ArrayList<ProductoPorCompra> lProductosPorCompra;
    SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
    
    //Constructor.
    public Compra(){  
        
        lProductosPorCompra = new ArrayList<>();
        
        //Fecha de registro - Fecha actual.
        Date fechaActual = new Date();
        this.fecha = fechaActual; 
    }
       
    //Métodos de acceso - Set.
    public void setId_compra(String id_compra){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_compra)) {
            this.id_compra = Integer.parseInt(id_compra);
        } 
        else { System.out.println("Formato inválido (IdCompra).");}     
    }
   
    public void setFecha(Date fecha){
        this.fecha = fecha; 
    }
    
    //Métodos de acceso - Get.
    public int getId_compra(){return this.id_compra;} 
    public Date getFecha(){return this.fecha;} 
    public String getString_fecha(){return sdf.format(this.fecha);} 
}