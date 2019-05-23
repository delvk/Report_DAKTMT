Mat query = spatial_histogram(); //query all histogram
for (size_t sampleIdx = 0; sampleIdx < _histograms.size(); sampleIdx++) {
    double dist = compareHist(_histograms[sampleIdx], query, HISTCMP_CHISQR_ALT);
    int label = _labels.at<int>((int)sampleIdx); //get the one's label with the lowest different
    
}
