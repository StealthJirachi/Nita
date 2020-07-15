#import "Nita.h"

BOOL enabled;

NSString* conditions = nil; // weather condition which will be converted to an emoji
NSString* weatherString = nil; // emoji will be assigned to this variable
NSString* languageCode = nil; // language code to detect device language

%group Nita

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 {

	%orig; // making sure originalText is being initialized before comparing it

	if (!([[self originalText] containsString:@":"] || [[self originalText] containsString:@"%"] || [[self originalText] containsString:@"3G"] || [[self originalText] containsString:@"4G"] || [[self originalText] containsString:@"5G"] || [[self originalText] containsString:@"LTE"])) {

		// detect device language and convert current condition to emoji
		if ([languageCode containsString:@"en"])
			[self enEmojis];
		else if ([languageCode containsString:@"fr"])
			[self frEmojis];

		// assign the emoji (and optionally the temperature or onyl text) to the carrier
		if (showEmojiSwitch && !showTemperatureSwitch)
			%orig(weatherString);
		else if (showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]]); // that's why i use a variable for the condition, so i can easily add the temperature
		else if (!showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]]);
		else
			%orig(conditions);
	} else {
		%orig;
	}

}

// libPDDokdo currently only returns the condition in the language which the device has set so i have to convert it myself

// English
%new
- (void)enEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"sun"] || [conditions containsString:@"Sun"]) {
		if ([conditions isEqualToString:@"Sunny"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Mostly Sunny"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"clear"] || [conditions containsString:@"Clear"]) {
		if ([conditions isEqualToString:@"Clear"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Mostly Clear"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"cloud"] || [conditions containsString:@"Cloud"]) {
		if ([conditions isEqualToString:@"Cloudy"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Mostly Cloudy"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Partly Cloudy"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"showers"] || [conditions containsString:@"thunder"] || [conditions containsString:@"Showers"] || [conditions containsString:@"Thunder"]) {
		if ([conditions isEqualToString:@"Showers"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Thundershowers"])
			weatherString = @"⛈";
		else if ([conditions containsString:@"Thunder"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"snow"] || [conditions containsString:@"Snow"]) {
		weatherString = @"🌨";
		return;
	}

}

// French
%new
- (void)frEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"Ensoleillé"] || [conditions containsString:@"ensoleillé"]) {
		if ([conditions isEqualToString:@"Ensoleillé"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Plutôt ensoleillé"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"Dégagé"] || [conditions containsString:@"dégagé"]) {
		if ([conditions isEqualToString:@"Dégagé"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Ciel plutôt dégagé"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"Nuage"] || [conditions containsString:@"nuage"] || [conditions containsString:@"Belles éclaircies"]) {
		if ([conditions isEqualToString:@"Nuageux"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Nuages prédominants"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Quelques nuages"])
			weatherString = @"🌤";
		else if  ([conditions isEqualToString:@"Belles éclaircies"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"pluie"] || [conditions containsString:@"Pluie"] || [conditions containsString:@"averses"] || [conditions containsString:@"Averses"]) {
		if ([conditions isEqualToString:@"Averses"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Averses orageuses"])
			weatherString = @"⛈";
		else if ([conditions isEqualToString:@"Pluie"])
			weatherString = @"🌧";
		else
			weatherString = @"🌦";
		return;
	}

	// Thunderstorms
	if ([conditions containsString:@"Orage"]) {
		if ([conditions containsString:@"Orages"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"Neige"] || [conditions containsString:@"neige"]) {
		weatherString = @"🌨";
		return;
	}

}

// German
%new
- (void)enEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"Sonne"] || [conditions containsString:@"Sonne"]) {
		if ([conditions isEqualToString:@"Sonnig"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Meist sonnig"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"clear"] || [conditions containsString:@"Wolkenlos"]) {
		if ([conditions isEqualToString:@"Wolkenlos"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Meist Wolkenlos"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"cloud"] || [conditions containsString:@"Wolke"]) {
		if ([conditions isEqualToString:@"Bewölkt"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Meist bewölkt"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Teilweise bewölkt"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"Schauer"] || [conditions containsString:@"Donner"] || [conditions containsString:@"Regen"] || [conditions containsString:@"Donner"]) {
		if ([conditions isEqualToString:@"Schauer"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Gewitter"])
			weatherString = @"⛈";
		else if ([conditions containsString:@"Donner"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"Schnee"] || [conditions containsString:@"Schnee"]) {
		weatherString = @"🌨";
		return;
	}

}


%end

// Hide Breadcrumbs

%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider // iOS 13

+ (BOOL)_shouldAddBreadcrumbToActivatingSceneEntity:(id)arg1 sceneHandle:(id)arg2 withTransitionContext:(id)arg3 {

	if (hideBreadcrumbsSwitch)
		return NO;
	else
		return %orig;

}

%end

%hook SBMainDisplaySceneManager // iOS 12

- (BOOL)_shouldBreadcrumbApplicationSceneEntity:(id)arg1 withTransitionContext:(id)arg2 {

	if (hideBreadcrumbsSwitch)
		return NO;
	else
		return %orig;

}

%end

// Update Weather Data

%hook SBControlCenterController // when opening control center

- (void)_willPresent {

	%orig;

	if (refreshWeatherDataControlCenterSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBCoverSheetPrimarySlidingViewController // when sliding down notitication center

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	if (refreshWeatherDataNotificationCenterSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBBacklightController // when turning on screen

- (void)turnOnScreenFullyWithBacklightSource:(long long)source {

	%orig;

	if (source != 26 && refreshWeatherDataDisplayWakeSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%end

%group NitaIntegrityFail

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated {

    %orig;
    if (!dpkgInvalid) return;
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Nita"
		message:@"Seriously? Pirating a free Tweak is awful!\nPiracy repo's Tweaks could contain Malware if you didn't know that, so go ahead and get Nita from the official Source https://repo.litten.love/.\nIf you're seeing this but you got it from the official source then make sure to add https://repo.litten.love to Cydia or Sileo."
		preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

			UIApplication* application = [UIApplication sharedApplication];
			[application openURL:[NSURL URLWithString:@"https://repo.litten.love/"] options:@{} completionHandler:nil];

	}];

		[alertController addAction:cancelAction];

		[self presentViewController:alertController animated:YES completion:nil];

}

%end

%end

%ctor {

	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/love.litten.nita.list"];

    if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/love.litten.nita.md5sums"];

    if (dpkgInvalid) {
        %init(NitaIntegrityFail);
        return;
    }

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.nitapreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// Visibility
	[preferences registerBool:&showEmojiSwitch default:YES forKey:@"showEmoji"];
	[preferences registerBool:&showTemperatureSwitch default:NO forKey:@"showTemperature"];

	// Miscellaneous
	[preferences registerBool:&hideBreadcrumbsSwitch default:YES forKey:@"hideBreadcrumbs"];

	// Data Refreshing
	[preferences registerBool:&refreshWeatherDataControlCenterSwitch default:YES forKey:@"refreshWeatherDataControlCenter"];
	[preferences registerBool:&refreshWeatherDataNotificationCenterSwitch default:NO forKey:@"refreshWeatherDataNotificationCenter"];
	[preferences registerBool:&refreshWeatherDataDisplayWakeSwitch default:YES forKey:@"refreshWeatherDataDisplayWake"];

	if (!dpkgInvalid && enabled) {
        BOOL ok = false;
        
        ok = ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@%@%@%@%@%@%@%@%@%@%@.nita.md5sums", @"l", @"o", @"v", @"e", @".", @"l", @"i", @"t", @"t", @"e", @"n"]]
        );

        if (ok && [@"litten" isEqualToString:@"litten"]) {
			NSLocale* locale = [NSLocale autoupdatingCurrentLocale];
			languageCode = locale.languageCode;
			%init(Nita);
            return;
        } else {
            dpkgInvalid = YES;
        }
    }

}
