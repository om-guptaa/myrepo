import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class Main {
    public static void main(String[] args) {
        String filePath1 = "path/to/file1.yaml";
        String filePath2 = "path/to/file2.yaml";

        List<NetworkPolicyEgressRule> file1Rules = getEgressRules(filePath1);
        List<NetworkPolicyEgressRule> file2Rules = getEgressRules(filePath2);

        // Mapping metadata names with their corresponding hostnames
        Map<String, List<String>> file1MetaDataMap = mapMetadataNamesWithHosts(file1Rules);
        Map<String, List<String>> file2MetaDataMap = mapMetadataNamesWithHosts(file2Rules);

        // Finding missing hosts for each metadata name in file2
        List<String[]> missingHosts = new ArrayList<>();
        for (String metadataName : file1MetaDataMap.keySet()) {
            if (file2MetaDataMap.containsKey(metadataName)) {
                List<String> file1Hosts = file1MetaDataMap.get(metadataName);
                List<String> file2Hosts = file2MetaDataMap.get(metadataName);
                for (String host : file1Hosts) {
                    if (!file2Hosts.contains(host)) {
                        missingHosts.add(new String[] { metadataName, host });
                    }
                }
            }
        }

        // Writing missing hosts to CSV file
        try {
            FileWriter csvWriter = new FileWriter("missing_hosts.csv");
            csvWriter.append("Metadata Name, Missing Host\n");
            for (String[] row : missingHosts) {
                csvWriter.append(String.join(",", row) + "\n");
            }
            csvWriter.flush();
            csvWriter.close();
            System.out.println("Missing hosts written to missing_hosts.csv");
        } catch (IOException e) {
            System.out.println("Error writing to CSV file: " + e.getMessage());
        }
    }

    private static List<NetworkPolicyEgressRule> getEgressRules(String filePath) {
        List<NetworkPolicyEgressRule> egressRules = new ArrayList<>();
        Yaml yaml = new Yaml();
        try {
            Iterable<Object> documents = yaml.loadAll(new File(filePath));
            for (Object document : documents) {
                NetworkPolicy networkPolicy = (NetworkPolicy) document;
                if (networkPolicy.getTypes().contains("Egress")) {
                    List<NetworkPolicyEgressRule> egress = networkPolicy.getEgress();
                    if (egress != null) {
                        egressRules.addAll(egress);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error reading YAML file: " + e.getMessage());
        }
        return egressRules;
    }

    private static Map<String, List<String>> mapMetadataNamesWithHosts(List<NetworkPolicyEgressRule> rules) {
        Map<String, List<String>> metaDataMap = new HashMap<>();
        for (NetworkPolicyEgressRule rule : rules) {
            String metadataName = rule.getMetadataName();
            NetworkPolicyPeer destination = rule.getDestination();
            if (destination != null) {
                List<String> hosts = destination.getHosts();
                if (hosts != null) {
                    if (metaDataMap.containsKey(metadataName)) {
                        metaDataMap.get(metadataName).addAll(hosts);
                    } else {
                        metaDataMap.put(metadataName, hosts);
                    }
                }
            }
        }
        return metaDataMap;
    }
}




import java.util.*;
import org.yaml.snakeyaml.*;
import java.io.*;

public class NetworkPolicyParser {
    public static void main(String[] args) throws FileNotFoundException {
        // Load the YAML file into a String
        String yamlFile = new Scanner(new File("network_policy.yaml")).useDelimiter("\\Z").next();
        
        // Parse the YAML file into a Map
        Yaml yaml = new Yaml();
        List<Map<String, Object>> policies = (List<Map<String, Object>>) yaml.load(yamlFile);

        // Loop over each policy and extract the metadata.name and ports
        for (Map<String, Object> policy : policies) {
            Map<String, Object> metadata = (Map<String, Object>) policy.get("metadata");
            String name = (String) metadata.get("name");
            List<Integer> ports = new ArrayList<Integer>();
            List<Map<String, Object>> egressList = (List<Map<String, Object>>) policy.get("spec.egress");
            for (Map<String, Object> egress : egressList) {
                List<Integer> portList = (List<Integer>) egress.get("ports");
                ports.addAll(portList);
            }
            System.out.println(name + ": " + ports);
        }
    }
}

