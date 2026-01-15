package org.acme;


public class Producto {
    public Long id;
    public String nombre;
    public Double precio;

    // Constructor vacío necesario para Jackson (JSON)
    public Producto() {}

    public Producto(Long id, String nombre, Double precio) {
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
    }
}