//
//  VisualAnchors.swift
//  VisualAnchors
//
//  Created by Julien Blatecky on 05/11/2015.
//  Copyright © 2016 Creatiwity. All rights reserved.
//
import UIKit

public extension UIView
{
    /// An AnchorGroup bound to this `UIView` used to set a `NSLayoutConstraint`
    ///
    /// This property is the public access of the `VisualAnchors` library used to easily set, update or remove a `NSLayoutConstraint`.
    ///
    /// ---
    ///
    /// ## Examples
    ///
    /// If you want to set a constraint binding the `trailing` edge of `view1` with the `leading` edge of `view2` with a constant of 20 between both views:
    ///
    ///     view1.anchors.trailing = 20 + view2.anchors.leading
    /// Here, `view1` and `view2` shares the same `superview`.
    ///
    /// If you want to set a constraint to bind the `top` edge of `view1` with the `top` edge of `view2` when the superviews are not the same:
    ///
    ///     view1.anchors.top = view2.anchors.top.ancestor(view2)
    ///
    /// Here, `view1` and `view2` does not share the same `superview`, but `view1` is a subview of `view2`. You should set the first common ancestor of both `views` to allow the constraint to be correctly added to the system.
    ///
    /// If you want to set a constraint to bind the `width` of `view1` with the half `width` of `view2` when the first common ancestor is `view2.superview`:
    ///
    ///     view1.anchors.width = view2.anchors.width.ancestor(view2.superview) / 2
    ///
    /// If you want to remove the previous constraint:
    ///
    ///     view.anchors.width = view2.anchors.width.ancestor(view2.superview).remove()
    ///
    /// If you want to set the width of the `view` to 40:
    ///
    ///     view.anchors.width = 40 + Anchor.myself
    ///
    /// If you want to remove the previous constraint:
    ///
    ///     view.anchors.width = Anchor.myself.remove()
    ///
    /// If you want to fill `view2` with `view1` with a margin of 15 all around `view1`, when `view1` is a subview of `view2`:
    ///
    ///     view1.anchors.fill = 15 + view2.anchors.fill.ancestor(view2)
    ///
    /// - note: When using Size Classes, keep in mind that the corresponding constraints won't be available and this library may fail to update an existing anchor until `viewWillLayoutSubviews` has been called.
    /// - seealso: `NSLayoutConstraint` for a full description of the constraint system.
    var anchors: AnchorGroup {
        get {
            return AnchorGroup(view: self)
        }
    }
}

open class AnchorGroup {
    let parent: UIView

    /// The centerX anchor, corresponding to the `NSLayoutAttribute.CenterX` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var centerX: Anchor {
        get {
            return Anchor(group: self, attribute: .centerX)
        }
        set(anchor) {
            bindAnchors(centerX, anchor2: anchor)
        }
    }
    /// The centerY anchor, corresponding to the `NSLayoutAttribute.CenterY` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var centerY: Anchor {
        get {
            return Anchor(group: self, attribute: .centerY)
        }
        set(anchor) {
            bindAnchors(centerY, anchor2: anchor)
        }
    }
    /// The center anchor, corresponding to the `NSLayoutAttribute.CenterX` and `NSLayoutAttribute.CenterY` attributes
    ///
    /// - note: To be used with another `center` anchor
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var center: Anchor {
        get {
            return Anchor(group: self, anchors: [self.centerX, self.centerY])
        }
        set(anchors) {
            bindAnchors(center, anchor2: anchors)
        }
    }

    /// The top anchor, corresponding to the `NSLayoutAttribute.Top` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var top: Anchor {
        get {
            return Anchor(group: self, attribute: .top)
        }
        set(anchor) {
            bindAnchors(top, anchor2: anchor)
        }
    }
    /// The bottom anchor, corresponding to the `NSLayoutAttribute.Bottom` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var bottom: Anchor {
        get {
            return Anchor(group: self, attribute: .bottom)
        }
        set(anchor) {
            bindAnchors(bottom, anchor2: anchor)
        }
    }
    /// The leading anchor, corresponding to the `NSLayoutAttribute.Leading` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var leading: Anchor {
        get {
            return Anchor(group: self, attribute: .leading)
        }
        set(anchor) {
            bindAnchors(leading, anchor2: anchor)
        }
    }
    /// The trailing anchor, corresponding to the `NSLayoutAttribute.Trailing` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var trailing: Anchor {
        get {
            return Anchor(group: self, attribute: .trailing)
        }
        set(anchor) {
            bindAnchors(trailing, anchor2: anchor)
        }
    }
    /// The fill anchor, corresponding to the `NSLayoutAttribute.Top`, `NSLayoutAttribute.Bottom`, `NSLayoutAttribute.Leading` and `NSLayoutAttribute.Trailing` attributes
    ///
    /// Constant used with this anchor will see its sign reversed with `NSLayoutAttribute.Bottom` and `NSLayoutAttribute.Trailing` to allow a margin-like behavior.
    ///
    /// - note: To be used with another `fill` anchor
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var fill: Anchor {
        get {
            return Anchor(group: self, anchors: [self.top, self.bottom, self.leading, self.trailing])
        }
        set(anchors) {
            bindAnchors(fill, anchor2: anchors)
        }
    }

    /// The width anchor, corresponding to the `NSLayoutAttribute.Width` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var width: Anchor {
        get {
            return Anchor(group: self, attribute: .width)
        }
        set(anchor) {
            bindAnchors(width, anchor2: anchor)
        }
    }
    /// The height anchor, corresponding to the `NSLayoutAttribute.Height` attribute
    ///
    /// - seealso: `NSLayoutAttribute` for a full description of the attributes.
    open var height: Anchor {
        get {
            return Anchor(group: self, attribute: .height)
        }
        set(anchor) {
            bindAnchors(height, anchor2: anchor)
        }
    }

    internal init(view: UIView)
    {
        parent = view
    }

    fileprivate func bindAnchors(_ anchor1: Anchor, anchor2: Anchor)
    {
        if let commonAncestor = findCommonAncestor(anchor1, anchor2: anchor2)
        {
            if let anchors1 = anchor1.anchors,
                let anchors2 = anchor2.anchors
            {
                // Composite anchor
                if (anchors1.count == anchors2.count)
                {
                    var index = 0

                    for anchor1 in anchors1
                    {
                        anchor2.copyTo(anchors2[index])
                        bindAnchors(anchor1, anchor2: anchors2[index])
                        index += 1
                    }
                }
            }
            else
            {
                if anchor2.reset
                {
                    if let (constraint, _) = findConstraintWithAncestor(commonAncestor, anchor1: anchor1, anchor2: anchor2)
                    {
                        // Remove existing constraint
                        commonAncestor.removeConstraint(constraint)
                    }
                }
                else
                {
                    if anchor2.creation
                    {
                        // Create new constraint (optimized path)
                        createConstraintWithAncestor(commonAncestor, anchor1: anchor1, anchor2: anchor2)
                    }
                    else if let (constraint, reversed) = findConstraintWithAncestor(commonAncestor, anchor1: anchor1, anchor2: anchor2)
                    {
                        if reversed || constraint.relation != anchor2.relation || constraint.multiplier != CGFloat(anchor2.multiplier) || constraint.priority != anchor2.priority
                        {
                            // Replace existing constraint
                            commonAncestor.removeConstraint(constraint)
                            createConstraintWithAncestor(commonAncestor, anchor1: anchor1, anchor2: anchor2)
                        }
                        else
                        {
                            // Update existing constraint
                            constraint.constant = CGFloat(anchor2.constant) * (reversed ? -1 : 1)
                        }
                    }
                    else
                    {
                        // Create new constraint
                        createConstraintWithAncestor(commonAncestor, anchor1: anchor1, anchor2: anchor2)
                    }
                }
            }
        }
    }

    fileprivate func createConstraintWithAncestor(_ ancestor: UIView, anchor1: Anchor, anchor2: Anchor)
    {
        let constraint = NSLayoutConstraint(
            item: parent,
            attribute: anchor1.attribute,
            relatedBy: anchor2.relation,
            toItem: anchor2.group?.parent,
            attribute: anchor2.attribute,
            multiplier: CGFloat(anchor2.multiplier),
            constant: CGFloat(anchor2.constant)
        )
        
        parent.translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = anchor2.priority
        ancestor.addConstraint(constraint)
    }

    fileprivate func findCommonAncestor(_ anchor1: Anchor, anchor2: Anchor) -> UIView?
    {
        if let commonAncestor = anchor2.commonAncestor
        {
            return commonAncestor
        }
        else if let group2 = anchor2.group
        {
            if let superview1 = parent.superview
            {
                if superview1 == group2.parent
                {
                    return superview1
                }
                else if let superview2 = group2.parent.superview
                {
                    if superview1 == superview2
                    {
                        return superview1
                    }
                }
            }
        }
        else if anchor2.attribute == .notAnAttribute
        {
            return parent
        }

        return nil
    }

    fileprivate func findConstraintWithAncestor(_ commonAncestor: UIView, anchor1: Anchor, anchor2: Anchor) -> (constraint: NSLayoutConstraint, reversed: Bool)?
    {
        var reversed = false

        if let constraintIndex = commonAncestor.constraints.index(where: {
            let sameFirst: Bool = $0.firstItem as? UIView == self.parent && $0.firstAttribute == anchor1.attribute
            let sameSecond: Bool = $0.secondItem as? UIView == anchor2.group?.parent && $0.secondAttribute == anchor2.attribute

            if !(sameFirst && sameSecond)
            {
                let sameFirstReversed: Bool = $0.firstItem as? UIView == anchor2.group?.parent && $0.firstAttribute == anchor2.attribute
                let sameSecondReversed: Bool = $0.secondItem as? UIView == self.parent && $0.secondAttribute == anchor1.attribute
                reversed = true
                return sameFirstReversed && sameSecondReversed
            }
            else
            {
                reversed = false
                return true
            }
        })
        {
            return (commonAncestor.constraints[constraintIndex], reversed)
        }
        else
        {
            return nil
        }
    }
}

open class Anchor {
    internal var group: AnchorGroup?
    internal let attribute: NSLayoutAttribute
    internal var constant: Double = 0
    internal var multiplier: Double = 1
    internal var commonAncestor: UIView?
    internal var relation: NSLayoutRelation = .equal
    internal var priority: Float = 1000
    internal var reset: Bool = false
    internal var creation: Bool = false

    internal var anchors: [Anchor]?

    internal init(group: AnchorGroup, attribute: NSLayoutAttribute)
    {
        self.group = group
        self.attribute = attribute
    }

    fileprivate init(group: AnchorGroup, anchors: [Anchor])
    {
        self.group = group
        self.anchors = anchors
        self.attribute = .notAnAttribute
    }

    fileprivate init()
    {
        self.attribute = .notAnAttribute
    }

    fileprivate func copyTo(_ anchor: Anchor)
    {
        anchor.constant = anchor.attribute == .trailing || anchor.attribute == .bottom ? -constant : constant
        anchor.multiplier = multiplier
        anchor.commonAncestor = commonAncestor
        anchor.relation = relation
        anchor.priority = priority
        anchor.reset = reset
        anchor.creation = creation
    }

    /// Sets the first common ancestor that will be used to update the constraint.
    ///
    /// - note: If the common ancestor is the direct superview of both views, you don't need to call this method
    /// - seealso: `addConstraint` method from `UIView`, for a full description of the ancestor.
    ///
    /// - parameters:
    ///   - UIView?: The first common ancestor
    /// - returns: The anchor to allow chainable calls
    open func ancestor(_ ancestor: UIView?) -> Anchor
    {
        commonAncestor = ancestor
        return self
    }

    /// Sets the constraint's relation to .equal.
    ///
    /// This method is one of the three methods that allow you to configure the relation (`NSLayoutRelation`) between two constraint:
    /// - `lessThanOrEqual`: `.lessThanOrEqual`
    /// - `equal`: `.equal`
    /// - `greaterThanOrEqual`: `.greaterThanOrEqual`
    ///
    /// Anchors always defaults to equal.
    ///
    /// - seealso: `relation` property from `NSLayoutConstraint`, for a full description of the relation.
    ///
    /// - returns: The anchor to allow chainable calls
    open func equal() -> Anchor
    {
        relation = .equal
        return self
    }

    /// Sets the constraint's relation to .greaterThanOrEqual.
    ///
    /// This method is one of the three methods that allow you to configure the relation (`NSLayoutRelation`) between two constraint:
    /// - `lessThanOrEqual`: `.lessThanOrEqual`
    /// - `equal`: `.equal`
    /// - `greaterThanOrEqual`: `.greaterThanOrEqual`
    ///
    /// Anchors always defaults to equal.
    ///
    /// - seealso: `relation` property from `NSLayoutConstraint`, for a full description of the relation.
    ///
    /// - returns: The anchor to allow chainable calls
    open func greaterThanOrEqual() -> Anchor
    {
        relation = .greaterThanOrEqual
        return self
    }

    /// Sets the constraint's relation to .greaterThanOrEqual.
    ///
    /// This method is one of the three methods that allow you to configure the relation (`NSLayoutRelation`) between two constraint:
    /// - `lessThanOrEqual`: `.lessThanOrEqual`
    /// - `equal`: `.equal`
    /// - `greaterThanOrEqual`: `.greaterThanOrEqual`
    ///
    /// Anchors always defaults to equal.
    ///
    /// - seealso: `relation` property from `NSLayoutConstraint`, for a full description of the relation.
    ///
    /// - returns: The anchor to allow chainable calls
    open func lessThanOrEqual() -> Anchor
    {
        relation = .lessThanOrEqual
        return self
    }

    /// Sets the constraint's priority.
    ///
    /// Priority always defaults to 1000.
    ///
    /// - seealso: `priority` property from `NSLayoutConstraint`, for a full description of the priority.
    ///
    /// - parameters:
    ///   - Float: The priority to use to update the constraint
    /// - returns: The anchor to allow chainable calls
    open func priority(_ priority: Float) -> Anchor
    {
        self.priority = priority
        return self
    }

    /// Prepares the constraint to be removed.
    ///
    /// - seealso: `removeConstraint` method from `UIView`.
    ///
    /// - returns: The anchor to allow chainable calls
    open func remove() -> Anchor
    {
        self.reset = true
        return self
    }
    
    /// Optimize the constraint to be created.
    ///
    /// - returns: The anchor to allow chainable calls
    open func create() -> Anchor
    {
        self.creation = true
        return self
    }

    /// An anchor used to set constant width or height constraint.
    ///
    /// This anchor is used when there is no second `UIView` to use in the constraint relationship.
    ///
    /// For instance, if you want to set the width of the `UIView` to 40:
    ///     // Set the width to 40
    ///     view.anchors.width = 40 + Anchor.myself
    ///
    open static var myself: Anchor {return Anchor()}
}

public func +(anchor: Anchor, constant: Double) -> Anchor
{
    anchor.constant += constant
    return anchor
}

public func +(constant: Double, anchor: Anchor) -> Anchor
{
    anchor.constant += constant
    return anchor
}

public func -(anchor: Anchor, constant: Double) -> Anchor
{
    anchor.constant -= constant
    return anchor
}

public func -(constant: Double, anchor: Anchor) -> Anchor
{
    anchor.constant -= constant
    return anchor
}

public func *(anchor: Anchor, multiplier: Double) -> Anchor
{
    anchor.multiplier *= multiplier
    return anchor
}

public func *(multiplier: Double, anchor: Anchor) -> Anchor
{
    anchor.multiplier *= multiplier
    return anchor
}

public func /(anchor: Anchor, multiplier: Double) -> Anchor
{
    anchor.multiplier /= multiplier
    return anchor
}

public func /(multiplier: Double, anchor: Anchor) -> Anchor
{
    anchor.multiplier /= multiplier
    return anchor
}
