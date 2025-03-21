import java.io.IOException;
import java.util.Arrays;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

public class WordCount {
    
    public static void main(String[] args) {
        SparkConf sparkConf = new SparkConf();
        sparkConf.setAppName("Spark WordCount example using Java");
        /* Tell Spark that we are running on this computer alone */
        sparkConf.setMaster("local");
        
        JavaSparkContext sparkContext = new JavaSparkContext(sparkConf);
        
        /* Reading input file */
        JavaRDD < String > textFile = sparkContext.textFile("input.txt");
        
        /* This code snippet creates an RDD (Resilient Distributed Dataset) of letters from each line of the input file and the flatMap function is used to split the text file into an ArrayList of letters by applying the split(" ") method to each line, which separates the line into individual letters. */        
        JavaRDD < String > letters = textFile.flatMap(l -> Arrays.asList(l.split(" ")).iterator());

        /*Generate Pair of Word with count */
        JavaPairRDD < String, Integer > pairs = letters.mapToPair(w -> new Tuple2<String, Integer>(w, 1));
        
        /* Aggregate Pairs of Same letters with count */
        JavaPairRDD < String, Integer > counts = pairs.reduceByKey((x, y) -> x + y);
        
  
        /* Deleting output directory if it already exists and saving the result file */
        String outputPath = "output"; // Change this to your desired output directory
        try {
            FileSystem.get(sparkContext.hadoopConfiguration()).delete(new Path(outputPath), true);
        } catch (IOException e) {
            e.printStackTrace();
        }

        /* Saving the result file */
        try {
            counts.saveAsTextFile(outputPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        /* System.out.println(counts.collect()); */
        System.out.println("Word Counts:");
        
        for (Tuple2<String, Integer> tuple : counts.collect()) {
            System.out.println(tuple._1() + ": " + tuple._2());
        }
        
        sparkContext.stop();
        sparkContext.close();
    }
}


