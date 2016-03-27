package ray;

import java.util.ArrayList;

import ray.math.Color;
import ray.math.Point3;
import ray.math.Ray;
import ray.math.Vector3;
import ray.surface.Surface;

/**
 * A simple ray tracer.
 * 
 * @author ags
 * @version ???
 */
public class RayTracer
{

    /**
     * The main method takes all the parameters an assumes they are input files
     * for the ray tracer. It tries to render each one and write it out to a PNG
     * file named <input_file>.png.
     * 
     * @param args
     *            A list of XML file names.
     */
    public static final void main(String[] args)
    {

        Parser parser = new Parser();
        for (int ctr = 0; ctr < args.length; ctr++)
        {

            // Get the input/output filenames.
            String inputFilename = args[ctr];
            String outputFilename = inputFilename + ".png";

            // Parse the input file
            Scene scene = (Scene) parser.parse(inputFilename, Scene.class);

            // Render the scene
            renderImage(scene);

            // Write the image out
            scene.getImage().write(outputFilename);
        }
    }

    /**
     * The renderImage method renders the entire scene.
     * 
     * @param scene
     *            The scene to be rendered
     */
    public static void renderImage(Scene scene)
    {
        final double MILLISECONDS_PER_SECOND = 1000.0;

        // Get the output image
        Image image = scene.getImage();

        // Timing counters
        long startTime = System.currentTimeMillis();

        for (int i_y = 0; i_y < image.getHeight(); i_y++)
        {
            for (int i_x = 0; i_x < image.getWidth(); i_x++)
            {
                Ray ray = scene.camera.getRay(i_x, i_y, 
                        image.getWidth(), image.getHeight());
//                System.out.println("Pixel: [" + i_x + ", " + i_y 
//                        + "]    Looking along ray: " + ray);
                
                Surface closestSurface = null;
                double closestT = Double.POSITIVE_INFINITY;
                for (Surface surface : scene.surfaces)
                {
                    // TODO: limit range.
                    boolean isHit = surface.intersect(ray, 0.0, 
                            Double.POSITIVE_INFINITY);
                    if (isHit)
                    {
                        double t = surface.intersectT(ray, 0.0, 
                                Double.POSITIVE_INFINITY);
                        if (t < closestT)
                        {
                            closestSurface = surface;
                            closestT = t;
                        }
                    }
                    
                }
                
                Color color = new Color(0, 0, 0);
                if (closestSurface != null)
                {
                    Point3 intersectPoint = new Point3(ray.origin);
                    Vector3 scaledRay = new Vector3(ray.direction);
                    scaledRay.scale(closestT);
                    intersectPoint.add(scaledRay);
                    
                    ArrayList<Light> nonShadeLights = new ArrayList<Light>();
                    for (Light light : scene.lights)
                    {
                        boolean shadow = false;
                        for (Surface surface : scene.surfaces)
                        {
                            // TODO: Bad using object equality
                            if (surface != closestSurface)
                            {
                                Vector3 lightDir = new Vector3();
                                lightDir.sub(light.position, intersectPoint);
                                lightDir.normalize();
                                
                                // Move the start point
                                Point3 startPoint = new Point3(intersectPoint);
                                Vector3 v = new Vector3(closestSurface.getNormal(intersectPoint));
                                v.scale(.000001);
                                startPoint.add(v);
                                
                                Ray lightRay = new Ray(startPoint, lightDir);
                                boolean lightBlocked = surface.intersect(lightRay, 0.0, 
                                        Double.POSITIVE_INFINITY);
                                if (lightBlocked)
                                {
                                    
                                    shadow = true;
                                    // TODO: Short circuit the other lights
                                }
                            }
                        }
                        
                        if (shadow == false)
                        {
                            nonShadeLights.add(light);
                        }
                    }
                    
                    // System.out.println("Intersect Point: " + intersectPoint);
                    color = closestSurface.getShader().shade(ray, 
                                intersectPoint, 
                                closestSurface.getNormal(intersectPoint), 
                                nonShadeLights);
                    //color = new Color(255, 0, 0);
                }

                image.setPixelColor(color, i_x, i_y);
            }
        }

        // Output time
        long totalTime = (System.currentTimeMillis() - startTime);
        System.out.println("Done.  Total rendering time: "
                + (totalTime / MILLISECONDS_PER_SECOND) + " seconds");
    }

}
