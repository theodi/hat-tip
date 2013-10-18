class Dataset

    attr_reader :dataset, :rights, :publisher
    DCAT = RDF::Vocabulary.new("http://www.w3.org/ns/dcat#")
    ODRS = RDF::Vocabulary.new("http://schema.theodi.org/odrs#")
    VOID = RDF::Vocabulary.new("http://rdfs.org/ns/void#")
    
    #TODO: want flexibility in creating, ideally let class discover
    #format of the data
    def initialize(url, opts={})
        @graph = load(url)
        if opts[:uri]
            @dataset = RDF::URI.new( opts[:uri] )
        else
            @dataset = find_dataset
        end            
        @rights = find_rights_statement      
        @publisher = find_publisher  
    end
    
    def uri
        return @dataset.to_s
    end
    
    def dataset_home
        url = object(DCAT.landingPage)
        return url if url
        url = object(RDF::FOAF.landingPage)
        return url if url
        return uri            
    end
    
    def title
        return first_literal( [RDF::DC.title, RDF::DC11.title] )
    end
    
    def publisher_name
        if @publisher
           text =  literal(RDF::FOAF.name, @publisher)
           return text if text
        end      
        text = literal(RDF::DC11.publisher)            
    end              
    
    def publisher_home
        if @publisher
           url = object(RDF::FOAF.homepage, @publisher)
           return url if url
        end                 
        return @publisher 
    end
        
    def attribution_text
        return literal(ODRS.attributionText, @rights)
    end
    
    def attribution_url
        return object(ODRS.attributionURL, @rights)
    end

    def issued
        return first_literal([ RDF::DC.issued, RDF::DC.created ])
    end
    
    def modified
        return literal( RDF::DC.modified, @dataset)
    end
    
    private
    
    def find_dataset()
        return first_of_type( [DCAT.Dataset, VOID.Dataset] )            
    end

    def find_rights_statement()
        return @graph.first_object(
            RDF::Query::Pattern.new( @dataset, RDF::DC.rights, nil ) )            
    end

    def find_publisher()
        return first_object( [RDF::DC.publisher, RDF::DC.creator ] )
    end
           
    def first_of_type(classes)
        term = nil
        classes.each do |clazz|
            term = @graph.first_subject(
                RDF::Query::Pattern.new( nil, RDF.type, clazz ) )
             break if term
        end
        term
    end
                             
    def first_object(properties, subject=@dataset)
        term = nil
        properties.each do |property|
            term = @graph.first_object(
                RDF::Query::Pattern.new( @dataset, property, nil ) )
             break if term
        end
        term
    end
    
    def first_literal(properties, subject=@dataset)
        value = nil
        properties.each do |property|
            value = literal(property, subject)
            break if value
        end
        value
    end
    
    def literal(property, subject=@dataset)
      return @graph.first_value(
          RDF::Query::Pattern.new( subject, property ) )
    end

    def object(property, subject=@dataset)
      obj = @graph.first_object(
          RDF::Query::Pattern.new( subject , property ) )
      return nil unless obj
      return obj.to_s
    end
    
    def load(url)

        #TODO Link in HTTP Header?            
        #Handling of link in <head/>
        #<link rel="alternate" type="application/rdf+xml" href="http://data.gov.uk/dataset/renewables_obligation-certificates_and_generation.rdf" />
        
        graph = RDF::Graph.load(url)
        
        resp = RestClient.get url, 
                :accept=>"text/turtle, application/n-triples, application/ld+json; q=1.0,application/rdf+xml; q=0.5, */*; q=0.2"            

        #TODO decide if this should error
        if resp.code != 200
            return nil
        end
        
        reader = RDF::Reader.for( :content_type => resp.headers[:content_type] )
        if reader == nil
            return nil
        end
        
        graph << reader.new( StringIO.new( resp.body ))
        
        return graph
    end
    
end