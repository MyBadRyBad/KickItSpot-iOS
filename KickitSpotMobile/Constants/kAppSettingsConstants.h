//
//  kAppSettingsConstants.h
//  KickitSpot
//
//  Created by Ryan Badilla on 2/14/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#ifndef kAppSettingsConstants_h
#define kAppSettingsConstants_h


#endif 

typedef enum ReleaseType {
    ReleaseTypeProduction,
    ReleaseTypeStaging,
    ReleaseTypeDevelopment
} ReleaseType;

typedef enum DataSource {
    DataSourceParseBackend,
    DataSourceLocal,
    DataSourceLocalTest
} DataSource;


static ReleaseType const _releaseType = ReleaseTypeDevelopment;
static DataSource const _dataSource = DataSourceLocalTest;
