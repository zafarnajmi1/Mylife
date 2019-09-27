
import Foundation

class JournalEntryLoader {
    
    var entries = [JournalEntry]()
    
    func loadLatest() {
        
        let entries = [
            JournalEntry(
                image: "https://www.businessdestinations.com/wp-content/uploads/2016/01/Social-lives.jpg"
            ),
            JournalEntry(
                image: "https://be.mit.edu/sites/default/files/images/7215347888_18d3522553_o.jpg"
            ),
            JournalEntry(
                image: "http://d2bdzzc4h8xl0w.cloudfront.net/wp-content/uploads/fitalicious/2013/06/Summer-Outting.jpg"
            ),
            JournalEntry(
                image: "http://www.ncsyes.co.uk/themix/sites/default/files/styles/inner_post_image/public/LAURA_CHURCH_BLOGPOST.png?itok=gCxoramE"
            ),
            JournalEntry(
            image: "https://www.edgehill.ac.uk/study/files/2017/03/Nightlife.jpg"
            ),
            JournalEntry(
            image: "https://lifeandthyme.com/wp-content/uploads/2015/01/boxcar-social-featured_L.jpg"
            ),
            JournalEntry(
            image: "http://packedhead.net/wp-content/uploads/2015/08/me-ira-tattoo.jpg"
            ),
            JournalEntry(
            image: "http://thevaultonline.com.au/wp-content/uploads/2016/08/TEASERSAVECASH-1800x650.jpg"
            )

        ]
        self.entries = entries
    }
    
}
