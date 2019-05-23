for(int n=0; n<neighbors; n++) {
    // sample points
    float x = static_cast<float>(radius * cos(2.0*CV_PI*n/static_cast<float>(neighbors)));
    float y = static_cast<float>(-radius * sin(2.0*CV_PI*n/static_cast<float>(neighbors)));
    // relative indices
    int fx = static_cast<int>(floor(x));
    int fy = static_cast<int>(floor(y));
    int cx = static_cast<int>(ceil(x));
    int cy = static_cast<int>(ceil(y));
    // fractional part
    float ty = y - fy;
    float tx = x - fx;
    // set interpolation weights
    float w1 = (1 - tx) * (1 - ty);
    float w2 =      tx  * (1 - ty);
    float w3 = (1 - tx) *      ty;
    float w4 =      tx  *      ty;
    // iterate through your data
    for(int i=radius; i < src.rows-radius;i++) {
        for(int j=radius;j < src.cols-radius;j++) {
            // calculate interpolated value
            float t = static_cast<float>(w1*src.at<_Tp>(i+fy,j+fx) + w2*src.at<_Tp>(i+fy,j+cx) + w3*src.at<_Tp>(i+cy,j+fx) + w4*src.at<_Tp>(i+cy,j+cx));
            // floating point precision, so check some machine-dependent epsilon
            dst.at<int>(i-radius,j-radius) += ((t > src.at<_Tp>(i,j)) || (std::abs(t-src.at<_Tp>(i,j)) < std::numeric_limits<float>::epsilon())) << n;
        }
}
