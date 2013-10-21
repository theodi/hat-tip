# Hat Tip: Attributing and Citing Data on the Web

A prototype that explores options for attributing and citing data on the web.

The application attempts to dynamically load metadata that describes the dataset and then uses that to 
provide some suggested ways of attributing and citing that dataset.

The application distinguishes between Attribution and Citation as described in [this blog post](http://blog.ldodds.com/2013/04/30/how-do-we-attribute-data/).

For instructions on how to describe a dataset and include attribution information, read the [Publisher Guide to the Open Data Rights Statement Vocabulary](https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md).

## Demonstration

A [demo version](http://hat-tip.herokuapp.com) of the application is available here:

    http://hat-tip.herokuapp.com

## Supported Metadata Formats

[Data Kitten](https://github.com/theodi/data_kitten) is used to do the metadata heavy-lifting, although some temporary 
additional code is used to allow for a couple of scenarios it doesn't yet handle.

Currently the code should be able to load metadata from:

* Datasets published as data packages in Github, e.g. [MOD Disposal Database](https://github.com/theodi/dataset-mod-disposals.git)
* Datasets from data.gov.uk
* Datasets published in CKAN instances
* Datasets that are published as Linked Data and described with DCAT, VOID, and the ODRS vocabulary
* Scientific datasets that have a DOI, e.g. such as those on [Figshare](figshare.com)

## Running the Application

The application is built with Ruby using the Sinatra framework. To run it you'll need to have Ruby 1.9 and Bundler installed. It should then 
be just a matter of running:

    sudo bundle install
    rackup



