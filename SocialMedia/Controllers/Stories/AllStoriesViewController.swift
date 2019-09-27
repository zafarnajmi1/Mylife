import UIKit

class AllStoriesViewController: UIViewController {
    
    @IBOutlet weak var scrollview: OHCubeView!
    var stories = [StoriesData] ()
    var pageIndex : NSInteger = 0
    var flagtime = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (stories.count == 0) { return }
        
        scrollview.cubeDelegate = self
        var array : [StoryView] = []
        for story in stories {
            let storyView : StoryView = StoryView(frame: scrollview.bounds)
            storyView.story = story
            storyView.delegate = self
            array.append(storyView)
        }
        scrollview.addChildViews(views: array)
        loadFirstView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func loadFirstView() {
        pageIndex = 0
        let storyView : StoryView = scrollview.childViews[0] as! StoryView
        storyView.showData()
    }
    
    func loadNext() {
        if (pageIndex == (stories.count  - 1)) { // Last Story
            
            loadFirstView()
            
            // dismissController()
            return
        }
        //        pageIndex = pageIndex + 1
        scrollview.scrollToViewAtIndex(index: (pageIndex + 1), animated: true)
    }
    
    func loadPrevious() {
        if (pageIndex == 0) { // Last Story
            return
        }
        //        pageIndex = pageIndex - 1
        scrollview.scrollToViewAtIndex(index: (pageIndex - 1), animated: true)
    }
    
    func loadStoryView(ByIndex _index : NSInteger) {
        pageIndex = _index
        let storyView : StoryView = scrollview.childViews[_index] as! StoryView
        storyView.showData()
    }
    
    func autoLoadStoryView(ByIndex _index : NSInteger) {
        pageIndex = _index
        scrollview.scrollToViewAtIndex(index: _index, animated: true)
    }
    
    func dismissController() {
        flagtime = true
        self.popVC()
        self.dismissVC(completion: nil)
    }
}

extension AllStoriesViewController : OHCubeViewDelegate {
    func cubeViewDidScroll(cubeView: OHCubeView) {
        let width : CGFloat = cubeView.frame.size.width;
        let page : NSInteger = NSInteger((cubeView.contentOffset.x + (0.5 * width)) / width);
        if (pageIndex != page) {
            loadStoryView(ByIndex: page)
        }
    }
}

extension AllStoriesViewController : StoryViewDelegate {
    func storyViewSegmentDidChange(AtIndex _index : Int) {
        
    }
    
    func storyViewSegmentCancel() {
        self.popVC()
        self.dismissVC(completion: nil)
    }
    
    func storyViewSegmentFinish(_ _view : StoryView) {
        if (pageIndex == (stories.count - 1)) {
            self.popVC()
            self.dismissVC(completion: nil)
        } else {
            autoLoadStoryView(ByIndex: pageIndex + 1)
        }
    }
    
    func storyViewDidEnd(_ _view : StoryView) {
        _view.removeFromSuperview()
        dismissController()
        FeedsHandler.sharedInstance.isStatusPosted = true
    }
    
    func loadNextStory() {
        if(flagtime){
            
        }
        else{
            loadNext()
            
        }
    }
    
    func loadPreviousStory() {
        if(flagtime){
            
        }
        else{
            loadPrevious()
            
        }
    }
}
