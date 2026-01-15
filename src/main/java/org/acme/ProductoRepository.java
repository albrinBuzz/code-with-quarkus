package org.acme;


import jakarta.enterprise.context.ApplicationScoped;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@ApplicationScoped
public class ProductoRepository {

    private List<Producto> lista = Collections.synchronizedList(new ArrayList<>());
    private AtomicLong idCounter = new AtomicLong(1);

    public List<Producto> listarTodos() {
        return lista;
    }

    public void guardar(Producto p) {
        p.id = idCounter.getAndIncrement();
        lista.add(p);
    }

    public void eliminar(Long id) {
        lista.removeIf(p -> p.id.equals(id));
    }

    public void actualizar(Long id, Producto p) {
        eliminar(id);
        p.id = id;
        lista.add(p);
    }
}
