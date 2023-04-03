
        try {
            InputStream inputStream = new FileInputStream("file.yaml");

            Yaml yaml = new Yaml();
            Iterable<Object> documents = yaml.loadAll(inputStream);

            for (Object document : documents) {
                if (document instanceof Map) {
                    Map<String, Object> map = (Map<String, Object>) document;

                    // Check if the document is of type NetworkPolicy
                    if (map.get("kind").equals("NetworkPolicy")) {
                        Map<String, Object> metadata = (Map<String, Object>) map.get("metadata");

                        // Extract the name field from metadata
                        String name = (String) metadata.get("name");

                        Map<String, Object> spec = (Map<String, Object>) map.get("spec");

                        // Extract the ports based on the egress structure
                        List<Map<String, Object>> egressList = (List<Map<String, Object>>) spec.get("egress");
                        for (Map<String, Object> egress : egressList) {
                            if (egress.containsKey("ports")) {
                                Object ports = egress.get("ports");
                                if (ports instanceof List) {
                                    List<String> portList = (List<String>) ports;
                                    for (String port : portList) {
                                        System.out.println("Name: " + name + ", Port: " + port);
                                    }
                                } else if (ports instanceof Map) {
                                    Map<String, Object> portMap = (Map<String, Object>) ports;
                                    String portNumber = String.valueOf(portMap.get("port"));
                                    Map<String, Object> protocol = (Map<String, Object>) portMap.get("protocol");
                                    String protocolName = (String) protocol.get("name");
                                    System.out.println("Name: " + name + ", Port: " + portNumber + ", Protocol: " + protocolName);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
