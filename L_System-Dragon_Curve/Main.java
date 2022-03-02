import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {
	
	public static void main(String[] args) throws Exception{
		
		ExecutorService executor = Executors.newFixedThreadPool(1);
		CompletableFuture<String> future = new CompletableFuture();
		
		executor.execute(() -> {future.supplyAsync(() -> new DragonCurve_Grammar().createDragonString())
								.thenApply(TheDragonString -> new DragonCurve_Implementation(TheDragonString))
								.thenAccept(TheDragonCurveImplementation -> new DragonCurve_Image(TheDragonCurveImplementation))
								;});
	}
	
}
