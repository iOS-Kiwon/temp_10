//
//  Mocha_ToastMessage.h
//  Mocha_ToastMessageTest
//
//  Created by Patrick Perini on 9/29/11.
//  Licensing information available in README.md
//


//The software is provided by Patrick Perini on an "AS IS" basis. Patrick Perini MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR PCS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//IN NO EVENT SHALL Patrick Perini BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF Patrick Perini HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#define Mocha_ToastMessageShortDuration     1.0
#define Mocha_ToastMessageDefaultDuration   2.0
#define Mocha_ToastMessageLongDuration      3.0

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Mocha_ToastMessage : UIView
{
    @private
    UILabel *_label;
}

@property (assign) CGFloat  duration;
@property (copy)   NSString *text;

+ (void)toastWithText:      (NSString *)aString;
+ (void)toastWithText:      (NSString *)aString inView:  (UIView *)view;
+ (void)toastWithDuration:  (CGFloat)aDuration  andText: (NSString *)aString;
+ (void)toastWithDuration:  (CGFloat)aDuration  andText: (NSString *)aString inView: (UIView *)view;

- (id)initWithText:         (NSString *)aString;
- (id)initWithDuration:     (CGFloat)aDuration  andText: (NSString *)aString;

- (void)display;
- (void)displayInView:      (UIView *)view;

@end
