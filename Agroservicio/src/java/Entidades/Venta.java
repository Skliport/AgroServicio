
package Entidades;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.regex.Pattern;

public class Venta {
    
    //Campos - Atributos.
    private int id_venta;
    private Date fecha;
    public ArrayList<ProductoPorVenta> lProductosPorVenta;
     SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
    
    //Constructor.
    public Venta(){ 
        lProductosPorVenta = new ArrayList<>();
        
        //Fecha de registro - Fecha actual.
        Date fechaActual = new Date();
        this.fecha = fechaActual; 
    }
 
    //Métodos de acceso - Set.
    public void setId_venta(String id_venta){
        
        //Enteros positivos * Max. Length = 10;
        if (Pattern.matches("^\\d{1,10}$", id_venta)) {
            this.id_venta = Integer.parseInt(id_venta);
        } 
        else { System.out.println("Formato inválido (id_venta).");}     
    }
    
    public void setFecha(Timestamp fecha){
        this.fecha = fecha;     
    }
        
    //Métodos de acceso - Get.
    public int getId_venta(){return this.id_venta;} 
    public Date getFecha(){return this.fecha;} 
    public String getString_fecha(){return sdf.format(this.fecha);} 
}