function D = computeDice(Sigma, Ref)

% Sigma intersect Ref
Intersect = Sigma.*Ref;
AbsIntersect = numel(Intersect(Intersect==1));
AbsRef = numel(Ref(Ref==1));
AbsSigma = numel(Sigma(Sigma==1));

% Sensitivity (true positive rate over the reference area)
% S(Sigma|Ref) = |Sigma intersect Ref|/|Ref|
S = AbsIntersect/AbsRef;

% Precision (true positive rate over the segmented area)
% P(Sigma|Ref) = |Sigma intersect Ref|/|Sigma|
P = AbsIntersect/AbsSigma;

% Sorensen-Dice
% D(Sigma|Ref) = 2|Sigma intersect Ref|/(|Sigma|+|Ref|)
% harmonic mean of sensitivity and precision: D = 2/(1/S + 1/P)
D = 2/(1/S + 1/P);
