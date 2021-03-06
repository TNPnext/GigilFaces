//
//  StaticImagesPopOverVCViewController.m
//  GigilFaces
//
//  Created by Nicole on 12/26/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "StaticImagesPopOverVCViewController.h"

@interface StaticImagesPopOverVCViewController ()

// Image names
@property (strong, nonatomic) NSMutableArray *mainArray;
@property (strong, nonatomic) NSArray *segmentOne;
@property (strong, nonatomic) NSArray *segmentTwo;
@property (strong, nonatomic) NSArray *segmentThree;

// Segmented control
@property (weak, nonatomic) IBOutlet UISegmentedControl *staticImagesSegmentControl;

@property (nonatomic) int cellTagCount;

@end

@implementation StaticImagesPopOverVCViewController

#pragma mark - Initalization

- (NSMutableArray *)mainArray {
    if (!_mainArray) _mainArray = [[NSMutableArray alloc] init];
    return _mainArray;
}

- (NSArray *)segmentOne {
    if (!_segmentOne) {
        _segmentOne = @[@"CurlyMoustacheSmall", @"BushyMoustacheSmall", @"PinchedMoustacheSmall", @"TrimMoustacheSmall"];
    }
    return _segmentOne;
}

- (NSArray *)segmentTwo {
    if (!_segmentTwo) {
        _segmentTwo = @[@"CircleRedSmall", @"CircleGreenSmall", @"CirclePurpleSmall", @"CircleBlackSmall",
                        @"TeardropDkBlueSmall", @"TeardropLtBlueSmall",
                        @"StarRedSmall", @"StarBlueSmall", @"StarYellowSmall",
                        @"TriangleRedSmall", @"TriangleGreenSmall", @"TrianglePurpleSmall", @"TriangleBlackSmall"];
    }
    return _segmentTwo;
}

- (NSArray *)segmentThree {
    if (!_segmentThree) {
        _segmentThree = @[@"BowTieSmall", @"TieSmall", @"BowlerSmall", @"TopHatSmall", @"ReporterHatSmall"];
    }
    return _segmentThree;
}

#pragma mark - Buttons

- (IBAction)segmentedControlSelectionChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.mainArray = [NSMutableArray arrayWithArray:self.segmentOne];
        [self.staticImagesCollectionView reloadData];
        self.cellTagCount = 0;
    }
    if (sender.selectedSegmentIndex == 1) {
        self.mainArray = [NSMutableArray arrayWithArray:self.segmentTwo];
        [self.staticImagesCollectionView reloadData];
        self.cellTagCount = 0;
    }
    if (sender.selectedSegmentIndex == 2) {
        self.mainArray = [NSMutableArray arrayWithArray:self.segmentThree];
        [self.staticImagesCollectionView reloadData];
        self.cellTagCount = 0;
    }
}

#pragma mark - UICollection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.mainArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    // Tag for cell
    cell.tag = self.cellTagCount;
    self.cellTagCount += 1;
    
    // Image
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainArray objectAtIndex:indexPath.row]]];
    imgView.contentMode = UIViewContentModeTopLeft;
    imgView.clipsToBounds = YES;
    imgView.frame = CGRectMake(0, 0, 100, 100);
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundView = imgView;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(106, 106);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get cell tag
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    int cellTag = (int)cell.tag;
    
    // Get category cell is in
    int category = (int)self.staticImagesSegmentControl.selectedSegmentIndex;
    
    [self.delegate staticImageAdded:cellTag category:category];
}


#pragma mark - Setup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set eye array as first collection view
    self.mainArray = [NSMutableArray arrayWithArray:self.segmentOne];
    
    // Collection view
    _staticImagesCollectionView.delegate = self;
    _staticImagesCollectionView.dataSource = self;
    [_staticImagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_staticImagesCollectionView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end