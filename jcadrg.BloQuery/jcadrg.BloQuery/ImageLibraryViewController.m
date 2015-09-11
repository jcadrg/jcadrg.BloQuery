//
//  ImageLibraryViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ImageLibraryViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import "CropImageViewController.h"

@interface ImageLibraryViewController () <CropImageViewControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *arraysOfAssets;

@end

@implementation ImageLibraryViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
        self.groups = [NSMutableArray array];
        self.arraysOfAssets = [NSMutableArray array];
    }
    
    return self;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable view"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIImage *cancelImage = [UIImage imageNamed:@"x"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelPressed:(UIBarButtonItem *)sender {
    [self.delegate imageLibraryViewController:self didCompleteWithImage:nil];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat minWidth = 100;
    NSInteger divisor = width / minWidth;
    CGFloat cellSize = width / divisor;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(width, 30);
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.groups removeAllObjects];
    [self.arraysOfAssets removeAllObjects];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [self.groups addObject:group];
            NSMutableArray *assets = [NSMutableArray array];
            [self.arraysOfAssets addObject:assets];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [assets addObject:result];
                }
            }];
            
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
        [alert show];
        
        [self.collectionView reloadData];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.groups removeAllObjects];
    [self.arraysOfAssets removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groups.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *imagesArray = self.arraysOfAssets[section];
    
    if (imagesArray) {
        return imagesArray.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger imageViewTag = 54321;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = imageViewTag;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    ALAsset *asset = self.arraysOfAssets[indexPath.section][indexPath.row];
    CGImageRef imageRef = asset.thumbnail;
    
    UIImage *image;
    
    if (imageRef) {
        image = [UIImage imageWithCGImage:imageRef];
    }
    
    imageView.image = image;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable view" forIndexPath:indexPath];
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        static NSInteger headerLabelTag = 2468;
        
        UILabel *label = (UILabel *)[view viewWithTag:headerLabelTag];
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.tag = headerLabelTag;
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            label.textAlignment = NSTextAlignmentCenter;
            
            label.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:235/255.0f alpha:1.0f];
            
            [view addSubview:label];
        }
        
        ALAssetsGroup *group = self.groups[indexPath.section];
        
        UIColor* textColor = [UIColor colorWithWhite:0.35 alpha:1];
        
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName : textColor,
                                         NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:14],
                                         NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
        
        NSAttributedString* attributedString;
        
        
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        
        if (groupName) {
            attributedString = [[NSAttributedString alloc] initWithString:groupName attributes:textAttributes];
        }
        
        label.attributedText = attributedString;
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select image");
    ALAsset *asset = self.arraysOfAssets[indexPath.section][indexPath.row];
    ALAssetRepresentation *representation = asset.defaultRepresentation;
    CGImageRef imageRef = representation.fullResolutionImage;
    
    UIImage *imageToCrop;
    
    if (imageRef) {
        imageToCrop = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
    }
    
    CropImageViewController *cropVC = [[CropImageViewController alloc] initWithImage:imageToCrop];
    cropVC.delegate = self;
    [self.navigationController pushViewController:cropVC animated:YES];
}

- (void)cropControllerFinishedWithImage:(UIImage *)croppedImage {
    [self.delegate imageLibraryViewController:self didCompleteWithImage:croppedImage];
}


@end
