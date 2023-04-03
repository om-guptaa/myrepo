
        Iterable<Object> documents = yaml.loadAll(file.getAbsolutePath());
        for (Object document : documents) {
            Map<String, Object> data = (Map<String, Object>) document;
            if (data.containsKey("metadata")) {
                Map<String, Object> metadata = (Map<String, Object>) data.get("metadata");
                if (metadata.containsKey("name")) {
                    String name = (String) metadata.get("name");
                    Map<String, Object> spec = (Map<String, Object>) data.get("spec");
                    List<Map<String, Object>> egressList = (List<Map<String, Object>>) spec.get("egress");
                    for (Map<String, Object> egress : egressList) {
                        if (egress.containsKey("ports")) {
                            Object ports = egress.get("ports");
                            if (ports instanceof List) {
                                List<Object> portList = (List<Object>) ports;
                                for (Object port : portList) {
                                    if (port instanceof String) {
                                        System.out.println(name + " - " + port);
                                    } else if (port instanceof Map) {
                                        Map<String, Object> portMap = (Map<String, Object>) port;
                                        String portNumber = portMap.get("port").toString();
                                        String protocol = portMap.get("protocol").toString();
                                        System.out.println(name + " - " + protocol + "/" + portNumber);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
