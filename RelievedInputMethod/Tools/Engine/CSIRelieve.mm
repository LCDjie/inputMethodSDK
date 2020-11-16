//
//  CSIRelieve.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "CSIRelieve.h"

niudun_input_mode *niudunime = NULL;
BOOL isImeReady = NO;
dispatch_queue_t niudunImeQueue = dispatch_queue_create("com.niudunIme.queue", NULL);
dispatch_queue_t niudunImeQueue1 = dispatch_queue_create("com.niudunIme.queue1", NULL);

inputData input;
outputResult output;
int ime_set_option[NIUDUN_MAX_OPTION_COUNT] = { 0 };
int ime_fuzzy_option[ND_IME_MAX_FUZZY_SETTING] = { 0 };

void clearInputData(void)
{
    input.inputkeys = 0;
    input.changeIndex = 0;
    input.selectCandidateIndex = 0;
    input.type = 0;
    input.pretext.clear();
    input.selectPinyin.clear();
}

void clearOutputData(void)
{
    output.pinyins.clear();
    output.candidateCount = 0;
    output.pinyinCount = 0;
    output.waitingConfirmText.clear();
    output.candidates.clear();
    output.nextChars.clear();
    output.outputText.clear();
    output.recommendWord.clear();
    output.inputkeys.clear();
    output.searchkeys.clear();
}

std::wstring Ns2Unicode(NSString *szNs) {
    if (!szNs) {
        return L"";
    }
    
    wstring rs = (wchar_t*)[szNs cStringUsingEncoding:NSUTF32StringEncoding];
    return rs;
}

NSString* Unicode2Ns(std::wstring szUnicode) {
    if (szUnicode.size() == 0) {
        return nil;
    }
    
    size_t length = sizeof(wchar_t)*szUnicode.size();
    unsigned char tempChar[length];
    memcpy(tempChar, szUnicode.data(), length);
    
    unsigned char dataChar[length / 2];
    for (int i=0; i<length; i++) {
        if (i % 4 == 0) {
            int j = (i / 4) * 2;
            dataChar[j] = tempChar[i];
        } else if (i % 4 == 1) {
            int j = (i / 4) * 2 + 1;
            dataChar[j] = tempChar[i];
        }
    }
    
    NSData *data = [[NSData alloc] initWithBytes:dataChar length:length / 2];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding];
    return result;
}

@implementation CSIRelieve

- (void)initialWithSetOption: (int[_Nonnull NIUDUN_MAX_OPTION_COUNT])set
                aFuzzyOption: (int[_Nonnull ND_IME_MAX_FUZZY_SETTING])fuzzy {
    if (niudunime == NULL) {
        niudunime = new niudun_input_mode();
    }
    
    for (int i=0; i<NIUDUN_MAX_OPTION_COUNT; i++) {
        ime_set_option[i] = set[i];
    }
    for (int i=0; i<ND_IME_MAX_FUZZY_SETTING; i++) {
        ime_fuzzy_option[i] = fuzzy[i];
    }
    
//    [self setupImeReay];
}

- (void)setupImeReay {
 
    vector<string> filePath;
    //用户词典数据路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    
    //系统词典路径
    NSString *dictBundlePath = [[NSBundle mainBundle] pathForResource:@"NiuDunDictBundle" ofType:@"bundle"];
    NSBundle *dictBundle = [NSBundle bundleWithPath:dictBundlePath];
    
    if (niudunime == NULL) {
        niudunime = new niudun_input_mode();
    }
    
    if ([GetKeyboardStatus status].currentKeyboardType == Keyboard_ENFull) {
        //英文词典
        NSString *englishDict = [dictBundle pathForResource:@"english_dict" ofType:@"bin"];
        const char *englishDictPath = [englishDict cStringUsingEncoding:NSUTF8StringEncoding];
        filePath.push_back(englishDictPath);
        niudunime->niudun_ime_initialize(&filePath, 2, 0);
    }else {
        //系统词典
        NSString *sysDict = [dictBundle pathForResource:@"sys_dict" ofType:@"bin"];
        const char *sysDictPath = [sysDict cStringUsingEncoding:NSUTF8StringEncoding];
        filePath.push_back(sysDictPath);
        
        //用户词典
        NSString *userDict = [documentPath stringByAppendingPathComponent:@"user_dict.bin"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userDict]) {
            NSData *emptyData = [NSData new];
            [[NSFileManager defaultManager] createFileAtPath:userDict contents:emptyData attributes:nil];
        }
        const char *userDictPath = [userDict cStringUsingEncoding:NSUTF8StringEncoding];
        filePath.push_back(userDictPath);
        
        //通讯录词典
        NSString *phoneBookDict = [documentPath stringByAppendingPathComponent:@"phoneBook_dict.bin"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:phoneBookDict]) {
            NSData *emptyData = [NSData new];
            [[NSFileManager defaultManager] createFileAtPath:phoneBookDict contents:emptyData attributes:nil];
        }
        const char *phoneBookDictPath = [phoneBookDict cStringUsingEncoding:NSUTF8StringEncoding];
        filePath.push_back(phoneBookDictPath);
        
        //特殊词典
        NSString *specialDict = [dictBundle pathForResource:@"special_dict" ofType:@"bin"];
        const char *specialDictPath = [specialDict cStringUsingEncoding:NSUTF8StringEncoding];
        filePath.push_back(specialDictPath);
        if ([GetKeyboardStatus status].currentKeyboardType == Keyboard_PinyinFull) {
            niudunime->niudun_ime_initialize(&filePath, 0, 0);
        }else {
            niudunime->niudun_ime_initialize(&filePath, 0, 1);
        }
    }
    input.option = ime_set_option;
    input.fuzzyList = ime_fuzzy_option;
    
    isImeReady = YES;
}

- (void)shiftKey:(int)status {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        niudunime->capslackStatus = status;
    });
}

- (void)keyboardItemClicked: (unsigned short)oneKey {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        unsigned short inputSearchKeys[MAX_INPUTKEYS_LENGTH] = { 0 };
        //拼音9键0~9
        if (oneKey >= 0x0030 && oneKey <= 0x0039) {
            inputSearchKeys[0] = oneKey &0xff;
            clearInputData();
            clearOutputData();
            input.inputkeys = inputSearchKeys;
            input.type = NIUDUN_INPUT_KEY;
            input.inputkeysLen = 1 ;
            niudunime->niudun_ime_get_candidate(&input, &output);
        } else if (oneKey >= 0x0061 && oneKey <= 0x007a) {
            //26个小写中文字母
            inputSearchKeys[0] = oneKey &0xff;
            clearInputData();
            clearOutputData();
            input.inputkeys = inputSearchKeys;
            input.type = NIUDUN_INPUT_KEY;
            input.inputkeysLen = 1 ;
            niudunime->niudun_ime_get_candidate(&input, &output);
        } else if (oneKey >= 0x0041 && oneKey <= 0x005a) {
            inputSearchKeys[0] = (oneKey + 0x0020)&0xff;
            //26个小写英文字母
            clearInputData();
            clearOutputData();
            input.inputkeys = inputSearchKeys;
            input.type = NIUDUN_INPUT_KEY;
            input.inputkeysLen = 1 ;
            niudunime->niudun_ime_get_candidate(&input, &output);
        }
        [strongSelf fetchResultData];
    });
}

- (void)separateWord {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        clearInputData();
        clearOutputData();
        unsigned short inputSearchKeys[MAX_INPUTKEYS_LENGTH] = { 0 };
        inputSearchKeys[0] = 0x0027;
        input.inputkeys = inputSearchKeys;
        input.inputkeysLen = 1;
        input.type = NIUDUN_INPUT_KEY;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)backDelete {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        clearInputData();
        clearOutputData();
        input.type = NIUDUN_DELETE_KEY;
        niudunime->niudun_ime_get_candidate(&input, &output);
        if (output.inputkeys.size() == 0) {
            input.type = NIUDUN_RESET_NORMAL;
            niudunime->niudun_ime_get_candidate(&input, &output);
        }
        [strongSelf fetchResultData];
    });
}

- (void)reset {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        clearInputData();
        clearOutputData();
        input.type = NIUDUN_RESET_NORMAL;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)symbolItemClicked: (unsigned short)oneKey {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        clearInputData();
        clearOutputData();
        unsigned short inputSearchKeys[MAX_INPUTKEYS_LENGTH] = { 0 };
        inputSearchKeys[0] = oneKey;
        input.inputkeys = inputSearchKeys;
        input.inputkeysLen =1 ;
        input.type = NIUDUN_BREAK_SYMBOL;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)clickCandidateAt: (int)index {
    if (index >= output.candidateCount) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }

        clearInputData();
        clearOutputData();
        input.selectCandidateIndex = index;
        input.type = NIUDUN_SELECT_CANDIDATE;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)clickCandidateBy: (NSString *)text{
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue1, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        clearInputData();
        clearOutputData();
        input.pretext = (wchar_t*)[text cStringUsingEncoding:NSUTF32StringEncoding];
        input.type = NIUDUN_GET_NGRAM;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)clickSpellLetter: (NSString *)letter {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        std::wstring pinyin = Ns2Unicode(letter);
        clearInputData();
        clearOutputData();
        input.selectPinyin = pinyin;
        input.type = NIUDUN_SELECT_PINYIN;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)fetchResultData {
    NSUInteger candidatesCount = (NSUInteger)output.candidateCount;
    NSMutableArray *candidates = [[NSMutableArray alloc] initWithCapacity:candidatesCount];
    for (int i=0; i<candidatesCount; i++) {
        wstring temp = output.candidates[i];
        NSString* candi = Unicode2Ns(temp);
        [candidates addObject:candi];
    }
    
    NSUInteger pinyinCount = (NSUInteger)output.pinyinCount;
    NSMutableArray *pinyins = [[NSMutableArray alloc] initWithCapacity:pinyinCount];
    for (int i=0; i<pinyinCount; i++) {
        wstring temp = output.pinyins[i];
        NSString *pinyin = Unicode2Ns(temp);
        [pinyins addObject:pinyin];
    }
    
    NSString *waitingConfirmStr = Unicode2Ns(output.waitingConfirmText);
    NSString *onScreenText = Unicode2Ns(output.outputText);
    NSString *preWordAndCurPinyin = Unicode2Ns(output.preWordAndCurPinyin);
    
    if ([self.delegate respondsToSelector:@selector(didFetchInputData:pinyin:confirmingPinyin:onScreenText: preWordAndCurPinyin:)]) {
        NSArray* candidatesData = [candidates copy];
        NSArray *pinyinData = [pinyins copy];

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.delegate didFetchInputData:candidatesData pinyin:pinyinData confirmingPinyin:waitingConfirmStr onScreenText:onScreenText preWordAndCurPinyin:preWordAndCurPinyin];
        });
    }
}

- (void)numberExchange {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isImeReady) {
            [strongSelf setupImeReay];
        }
        
        clearInputData();
        clearOutputData();
        input.type = NIUDUN_CHANGE_NUMBER;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)englishExchange {
    __weak typeof(self) weakSelf = self;
    dispatch_async(niudunImeQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setupImeReay];
        clearInputData();
        clearOutputData();
        input.type = NIUDUN_CHANGE_SEAMLESS;
        niudunime->niudun_ime_get_candidate(&input, &output);
        [strongSelf fetchResultData];
    });
}

- (void)zhKeyboardTypeExchange {
    dispatch_async(niudunImeQueue, ^{
        isImeReady = NO;
    });
}

- (void)keyboardDismiss {
    isImeReady = NO;
    dispatch_async(niudunImeQueue, ^{
        niudunime->niudun_ime_exit();
    });
}

@end
