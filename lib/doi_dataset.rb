class DOIDataset < Dataset
    
    def initialize(url, opts={})
        opts[:uri] = url
        super( url, opts )
    end    
    
    def supported?
        publisher_name != nil
    end
    
    def publisher_home
        nil
    end
    
    def publisher_name
        return literal(RDF::DC.creator)            
    end      
    
    def dataset_home
        uri
    end
    
    def issued
        return first_literal([ RDF::DC.date ])
    end
       
    def attribution_url
        uri
    end 
    
end