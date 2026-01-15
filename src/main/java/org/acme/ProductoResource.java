package org.acme;



import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/productos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProductoResource {

    @Inject
    ProductoRepository repository; // Inyección de dependencia (Parecido a @Autowired)

    @GET
    public List<Producto> listar() {
        return repository.listarTodos();
    }

    @POST
    public Response crear(Producto p) {
        repository.guardar(p);
        return Response.status(Response.Status.CREATED).entity(p).build();
    }

    @PUT
    @Path("/{id}")
    public void actualizar(@PathParam("id") Long id, Producto p) {
        repository.actualizar(id, p);
    }

    @DELETE
    @Path("/{id}")
    public void borrar(@PathParam("id") Long id) {
        repository.eliminar(id);
    }
}